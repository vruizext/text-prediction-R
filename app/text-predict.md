### How does it work?

<script type="text/javascript"
  src="//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

- Given a sequence of $k$ words $S=w_{1}, w_{2},\ldots,w_{k}$, a statistical language model assigns a probability to the sequence by means of a probability distribution $P(S)= P(w_1,w_2\ldots,w_k)$. Language models can also be used to predict the probability of upcoming words given the previous words.   

- In n-gram models, only the $n-1$ last words are considered relevant when predicting the next word (Markov assumption)
	- $P(w_{k}\mid w_{1}, w_{2},\ldots,w_{k-2}, w_{k-1}) \approx P(w_{k}\mid w_{k-n+1}, ... ,w_{k-1})$   
<br>
- Maximum-likelihood probability estimates (MLE), maximize the likelihood on the training data
	- $P_{ML}(w_{k}\mid w_{k-n+1},\ldots,w_{k-1}) = \frac{c(w_{k-n+1}^{k})}{c(w_{k-n+1}^{k-1})}$, where $w_{i}^{j} =w_{i}, w_{i+1},\ldots,w_{j}$  
	- $c(w_{i}^{j})$ is the number of occurrences of the n-gram $w_{i}^{j}$  <br>
- Problem of MLE: probabilities of n-grams unseen in training data are undefined   

- Solution: Mix higher order with lower order models  

- Interpolation vs backoff? Interpolation performs better

<br>

#### Building the Language Model

- Prepare corpus: clean and normalize text, remove non-ascii characters, delimit sentences with special marks, mark some special classes of words (urls, numbers, time, dates, ...)
  
- Split corpus in training (90%), development test (5%) and testing (5%)
  
- Prior to generate the n-grams model from training corpus, vocabulary is reduced to a subset of words covering 97.5% of total occurrences, that is, about 40,500 words. Any other words are marked as unknown
  
- Split training corpus in 4-grams and get their counts. Use the counts to build models containing MLE probabilities for 1-grams, 2-grams, 3-grams and 4-grams. Additionally, build four more models, including all possible partial matches: $(w_1,w_2,*,w_4),$ $(w_1, *,w_3,w_4),$ $(w_1, *,*,w_4),$ $(*, w_2, *,w_4)$. Then, the models are pruned, only n-grams with count > 1 and only the 3 predicted words $w_4$ with highest score for each context are saved  
  
- The eight n-gram models obtained in the previous step are interpolated with coefficients $a_{123} + a_{12} + a_{13} + a_{23} + a_{1} + a_{2} + a_{3} + a_{4}= 1$

$$P(w_1,w_2,w_3,w_4) = a_{123} \cdot P(w_{4}\mid w_1,w_2,w_3) + a_{13} \cdot P(w_{4}\mid w_1,*,w_3) + a_{12} \cdot P(w_{4}\mid w_1,w_2,*) + $$ $$a_{1} \cdot P(w_{4}\mid w_1,*,*) + a_{23} \cdot P(w_{4}\mid w_2,w_3) + a_{2} \cdot P(w_{4}\mid w_2,*) + a_{3} \cdot P(w_{4}\mid w_3) + a_4 \cdot P(w_{4})$$

<br>

#### Evaluation of the Language Model
- Training corpus: 3,840,000 lines / 91.25 million words  
<br>
- Development test corpus: 215,000 lines / 52 million words
	- used for tuning interpolation coeficients, in order to minimize entropy and maximize accuracy  
<br>
- Test corpus: 215,000 lines / 51.7 million words
	- Cross-entropy: 3.086 (4-grams)
	- Accuracy: 21.1% (4-grams)
	- Avg Speed: 15ms (per 4-gram query)  
<br>
- Disclaimer: Due to the limited resources available in shinyapps.io, the model had to be pruned a bit more, so the memory footprint of the app can fit the requirements. With this, accuracy dropped to 19.6%
	- 4-gram model, dropped ngrams with count lower than 2. Save only 2 best choices  
	- 3-gram model, save only 2 best predictions

<br>
