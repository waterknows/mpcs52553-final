# MPCS52553 Final Project

## 1. Introduction
This project uses Ruby on Rails as a resource provider to classify/tag user input with a pre-trained machine learning model (LDA). Please run the following commands to install necessary python3 packages first:
* pip install numpy pandas nltk scikit-learn lda
* python -m nltk.downloader popular

The python model is triggered by the "Tag" button under reviews/:id and will affect the presentation of other resources.

## 2. User Stories
* As a visitor, I want to sign up for a free account so that I can upload and manage reviews.
* As a visitor, I want to read user stories and business rules.
* As a visitor, I want to view the pre-trained lda model (see navbar-LDA Model).
* As a user, I want to view all reviews.
* As a user, I want to search reviews by key words (search bar).
* As a user, I want to see a specific review.
* As a user, I want to add new reviews.
* As a user, I want to delete a review that I entered.
* As a user, I want to edit a review that I entered.
* As a user, I want to use a pre-trained LDA model to tag reviews (Tag button).
* As a user, I want to see my account details.
* As a user, I want to modify my account details.
* As a user, I want to logout my account.

## 3. Business Rules
* A review consists of a title and content.
* 100 reviews are pre-populated from a csv to admin account
* Pre-trained LDA model is stored under /python folder
* Passwords must be encrypted.
