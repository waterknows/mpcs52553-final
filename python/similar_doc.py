import numpy as np
import string
import pandas as pd
import collections
import pickle
import sys
import nltk
import sklearn
import lda

nltkstop = {'of', 'wasn', 'out', 'on', 'they', 'isn', 'mustn', 'and', 'or', 'yours', 'had', 'hadn', 'until', 'ma', 'what', 'i', 'ain', 'his', 'as', 'those', 'into', 'in', 're', 'weren', 'because', 'other', 'between', 'own', 'where', 'there', 'for', 'not', 'against', 'd', 'once', 's', 'these', 'aren', 'herself', 'have', 'does', 'being', 'do', 'can', 'we', 'me', 'only', 'them', 'off', 'is', 'y', 'no', 'wouldn', 'did', 'further', 'itself', 'be', 'mightn', 'yourselves', 'with', 'hasn', 'here', 'shouldn', 'up', 'theirs', 'below', 'to', 'how', 'was', 'by', 'having', 't', 'down', 'after', 'don', 'their', 'should', 'more', 'our', 've', 'why', 'same', 'doesn', 'before', 'didn', 'when', 'he', 'both', 'ours', 'at', 'few', 'needn', 'any', 'm', 'which', 'from', 'under', 'o', 'again', 'will', 'himself', 'nor', 'who', 'through', 'above', 'ourselves', 'him', 'a', 'so', 'very', 'won', 'your', 'my', 'you', 'an', 'its', 'some', 'such', 'just', 'am', 'the', 'that', 'this', 'doing', 'whom', 'about', 'then', 'are', 'but', 'myself', 'if', 'has', 'haven', 'themselves', 'been', 'couldn', 'over', 'she', 'yourself', 'now', 'shan', 'll', 'most', 'during', 'all', 'while', 'were', 'each', 'it', 'her', 'than', 'too', 'hers'}

# prepare input for LDA model
def text2vec(docs,mode,vocabulary=None):
    count_vectorizer = sklearn.feature_extraction.text.CountVectorizer(max_df=0.5, min_df=2, tokenizer=lambda text: tokenize_lemmatize(text,lemmatize=True,stem=False), 
        lowercase=True)
    if vocabulary is not None:
        count_vectorizer = sklearn.feature_extraction.text.CountVectorizer(max_df=0.5, min_df=2, tokenizer=lambda text: tokenize_lemmatize(text,lemmatize=True,stem=False), 
            lowercase=True, vocabulary = vocabulary)
    try:
        vectors = count_vectorizer.fit_transform(docs)
    except:
        vectors = count_vectorizer.fit_transform([docs])
    vocab = count_vectorizer.get_feature_names()
    if mode == "save":
        with open('python/lda_vocab.pkl', 'wb') as f:
            pickle.dump(vocab, f)
        with open('python/lda_vector.pkl', 'wb') as f:
            pickle.dump(vectors, f)
    return vectors, vocab

#train LDA model
def train_lda(vector, topics, iters):
    lda_model = lda.LDA(n_topics=topics, n_iter=iters)
    X_topics = lda_model.fit_transform(vector)
    with open('python/lda.pkl', 'wb') as f:
        pickle.dump(lda_model, f)
    return X_topics, lda_model

#################Supplementary functions################
def tokenize_lemmatize(text, stop=None, lemmatize=False,stem=False):
    exclude = set(string.punctuation)
    text = "".join([ch for ch in text if ch not in exclude]) #removing punctuations
    tokens = [token for token in nltk.word_tokenize(text)] #tokenization
    if stop is None:
        stop=nltkstop
        tokens = [token for token in tokens if token not in stop] #removing stopwords
    if lemmatize==True:
        wnl = nltk.stem.WordNetLemmatizer()
        tokens = [wnl.lemmatize(t) for t in tokens] #lemmatizing
    if stem==True:
        lst = nltk.stem.lancaster.LancasterStemmer()
        tokens = [lst.stem(t) for t in tokens] #lemmatizing
    return tokens

def print_lda(lda_model, vocab):
    n_top_words = 10
    topic_summaries = []
    topic_word = lda_model.topic_word_  # get the topic words
    for i, topic_dist in enumerate(topic_word):
        topic_words = np.array(vocab)[np.argsort(topic_dist)][:-(n_top_words+1):-1]
        topic_summaries.append(' '.join(topic_words))
        print('Area {}: {}'.format(i, ' '.join(topic_words)))

def tag_lda(docs,vocab,model,mode):
    lda_keys = []
    test = text2vec(docs,mode,vocab)[0]
    for row in test:
        topic_num = model.transform(row).argmax()
        lda_keys.append(topic_num)
    return lda_keys

def main(type, mode, input_file=None, test_data=None):
    if input_file is not None:
        df=pd.read_csv(input_file)
    output=[]
    if mode == 'save':
        if type == 'lda':
            print('Preparing input...')
            vec, vocab = text2vec(df['description'],mode)
            print('Trainning and saving LDA...')
            X_topics, lda_model = train_lda(vec, 20, 2000)

    if mode == 'apply':
        if type == 'lda':
            with open('python/lda.pkl', 'rb') as f:
                lda_model=pickle.load(f)
            with open('python/lda_vocab.pkl', 'rb') as f:
                vocab=pickle.load(f)
            docs = test_data.split("===")
            output = tag_lda(docs,vocab,lda_model,mode) 
    return print(output)


if __name__ == "__main__":
    if sys.argv[2] == 'apply' and len(sys.argv)==4: #apply mode
        #try:
        main(type=sys.argv[1],mode=sys.argv[2],test_data=sys.argv[3])
        #except:
            #print('Correct usage: python similar_doc.py model(lda/doc2vec) apply test_data')
    elif sys.argv[2] == 'save' and len(sys.argv)==4: #save mode
        #try:
        main(type=sys.argv[1],mode=sys.argv[2],input_file=sys.argv[3])
        #except:
            #print('Correct usage: python similar_doc.py model(lda/doc2vec) save input_file')
            #e.g. python similar_doc.py Project_Goals_Data.xlsx doc2vec save
    else:
        print('Correct usage: python similar_doc.py model(lda/doc2vec) mode(save/apply) input_file (save mode) test_data(apply mode)')

