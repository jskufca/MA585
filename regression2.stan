//
// This Stan program defines a simple linear regression model

data {
  int<lower=0> N;
  vector[N] t;
  int<lower=0,upper=10> y[N];
}

parameters {
  real<lower=0,upper=1> a;
  real<lower=0> b;
}



model {
  y ~ binomial(10,a*(1-exp(-b*t)));
  b ~ normal(.5,3);
}
