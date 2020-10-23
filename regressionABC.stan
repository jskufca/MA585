//
// This Stan program defines a heirarchical binomial model to capture ABC exam data and make predictions
// https://mc-stan.org/docs/2_19/stan-users-guide/example-hierarchical-logistic-regression.html
// https://biologyforfun.wordpress.com/2016/11/10/hierarchical-models-with-rstan-part-1/

// data {
//   int<lower = 0> K; // number of students
//   int<lower = 0> N; // number of predictive tests
//   int<lower = 1,upper=K> kk[N];  //vector of group indices
//   vector[K,N] t;  // in
//   int<lower = 0, upper = 20> y[K,N];
// }
// parameters {
//   vector[K] alpha;
//   vector[K] beta;
//   
//   real mua;
//   real<lower=0> mub;
//   real<lower=0> sigmaa;
//   real<lower=0> sigmab;
// }
// model {
//   mua ~ normal(0, 2); //prio
//   // mub, sigmaa and sigmab have no prior
//   for (i in 1:2)
//     beta[ , i] ~ normal(mu[i], sigma[i]);
//   y ~ bernoulli_logit(beta[kk, 1] + beta[kk, 2] .* x);
// }


data {
  int<lower=1> N; //total number of observations
  int<lower=1> J; //the number of groups
  // int<lower=1> K; //number of columns in the model matrix K=1
  int<lower=1,upper=J> id[N]; //vector of group indeces
  vector[N] X; //the model matrix
  int<lower = 0, upper = 20> y[N];
}
parameters {
//  vector[K] gamma; //population-level regression coefficients
//  vector<lower=0>[K] tau; //the standard deviation of the regression coefficients
  real mua;
  real<lower=0> sigmaa;
  real mub;
  real<lower=0> sigmab;

//  vector[K] beta[J]; //matrix of group-level regression coefficients
//  real<lower=0> sigma; //standard deviation of the individual observations
  vector[J] alpha;
  vector[J] beta;

}
model {
  real eta[N]; //linear predictor
  int L[N]; // length of tests
  //priors
//  gamma ~ normal(0,5); //weakly informative priors on the regression coefficients
//  tau ~ cauchy(0,2.5); //weakly informative priors, see section 6.9 in STAN user guide
//  sigma ~ gamma(2,0.1); //weakly informative priors, see section 6.9 in STAN user guide
  mua ~ normal(0, 2); //prio
  mub ~ normal(0,10);
  // mub, sigmaa and sigmab have non-informative prior
  
  for(j in 1:J){
   alpha[j] ~ normal(mua,sigmaa); 
   beta[j] ~ normal(mub,sigmab);
  }
  
  for(n in 1:N){
    eta[n] = alpha[id[n]]+ X[n] * beta[id[n]]; //compute the linear predictor using relevant group-level regression coefficients 
    L[n]=20;
  }

  //likelihood
//  y ~ normal(mu,sigma);
   y ~ binomial_logit (L, eta);
}

generated quantities {
  vector[J] y_new;
  for (j in 1:J)
    y_new[j]= binomial_rng(20,inv_logit(alpha[j]+ 3 * beta[j]));
}



