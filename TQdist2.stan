// model associated Tianqi's localization problem
// This model is for a single location
// Rev 2 modified to include bounds on theta
data {
  int<lower=0> N;
  vector[2] X[N];
  real y[N];
}

transformed data {
  
}
parameters {
    vector<lower=0,upper=4>[2] theta; //position
    real<lower=0> meas_sd; //multiplicative error
}


transformed parameters {
  
}

model {
  real y_pred[N];
  for (i in 1:N) {
    y_pred[i]=distance(X[i],theta);
  }
  y~lognormal(log(y_pred),meas_sd);  // likelihood
  meas_sd ~ normal(.2,.4);  //prior
  }
generated quantities {
  // vector[N] log_lik;
  // for (i in 1:N) {
  //   log_lik[i] = binomial_lpmf(y[i] | n[i],theta[i]);
  //}

}
