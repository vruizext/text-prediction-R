## Text Prediction using N-Gram models

  The main goal of this project was to build a predictive text model from a text corpus. This was a "didactic" project, it was the assignment I had to complete for the Capstone Project of the [Coursera Data Science Specialization](https://www.coursera.org/specialization/jhudatascience/1). By the way, I got the max score from my student fellows in the peer review (:

The project consisted on several parts:
  1. Getting and cleaning the data
  2. Exploratory analysis
  3. Building n-gram model
  4. Building predictive model
  5. Testing and evaluating the model
  6. Building the UI (shiny app)

The [shiny app](https://bik-tor.shinyapps.io/text-prediction/) was the final deliverable product of the project, which provides an interface to access the prediction algorithm that I've built.

### How to run the code

In order to build the prediction model, all scripts  in the '''scripts''' folder need to be sourced. Some of them, only have to be executed once, others might have to be executed more times, in order to tune the model and improve the accuracy of the predictions.

  * 0_get data.R: downloads the corpus, unzip the files, and save the english files in rds format.

  * 1_sample.R: sample the corpus, getting some configurable percentage for training, devtest and test.
  
  * 2_preprocess.R: clean the data to make it ready for the tokenization.
  
  * 3_unigrams.R: get unigrams distribution of the training corpus, in order to build a dictionary of limited size which will be used in the next steps.
  
  * 4_tetragrams.R: build the 4-gram model from the training data.
  
  * 5_mle-model.R: build a prediction model using MLE probabilities calculated from the 4-gram model.
  
  * 6_devtest.R: test the model with the devtest set, try several configurations for interpolation weights, in order to find which one minimizes the cross entropy.
  
  * 7_test.R:  test the best set of coefficients obtained in the previous step with the test data set to validate the model.
  
