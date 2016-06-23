function p = predict(theta1, theta2, X)
%PREDICT Predict whether the label is 0 or 1 using learned logistic 
%regression parameters theta
%   p = PREDICT(theta, X) computes the predictions for X using a 
%   threshold at 0.5 (i.e., if sigmoid(theta'*x) >= 0.5, predict 1)

m = size(X, 1); % Number of training examples


% You need to return the following variables correctly
p = zeros(m, 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Complete the following code to make predictions using
%               your learned logistic regression parameters. 
%               You should set p to a vector of 0's and 1's
%


%Reshape X matrix
A = ones(2,1);
a1 = [A X];

%Compute first layer
z2 = a1*theta1';
a2 = sigmoid(z2);

%Add bias neuron to first layer
a2 = [A a2];

%Compute second layer (output)

z3 = a2*theta2;
a3 = sigmoid(z3);


[~,p] = max(a3, [], 2);


% =========================================================================


end
