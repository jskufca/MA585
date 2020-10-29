// model associated Tianqi's localization problem
// This model is for a single location
// Rev 2 modified to include bounds on theta
// Rev 3 modified to include constraint that theta1+theta2=1.4
data {
  int<lower=0> N;
  vector[2] X[N];
  real y[N];
}

transformed data {
  
}
parameters {
  simplex[2] s;// simplex
  //vector<lower=0,upper=4>[2] theta; //position
    real<lower=0> meas_sd; //multiplicative error
}


transformed parameters {
  vector<lower=0,upper=4>[2] theta; //position
  theta=s*1.4;
  
}

model {
  real y_pred[N];
  real v;
  v=theta[1]+theta[2];
  for (i in 1:N) {
    y_pred[i]=distance(X[i],theta);
  }
  y~lognormal(log(y_pred),meas_sd);  // likelihood
  meas_sd ~ normal(.2,.4);  //prior
  v=1.4;
  }
generated quantities {
  // vector[N] log_lik;
  // for (i in 1:N) {
  //   log_lik[i] = binomial_lpmf(y[i] | n[i],theta[i]);
  //}

}
