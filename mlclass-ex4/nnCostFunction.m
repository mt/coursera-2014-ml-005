function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m

a1 = [ones(m, 1) X]; % Add ones as bias
z2 = (a1 * Theta1');
a2 = sigmoid(z2);

a2 = [ones(m,1) a2]; % Add ones as bias
z3 = (a2 * Theta2');
hypothesis = a3 = sigmoid(z3);

yMatrix = cell2mat( arrayfun( @(x) x == y, 1:num_labels, 'UniformOutput', false ) );

costWhenYis1 = -yMatrix .* log(hypothesis);
costWhenYis0 = (1 - yMatrix) .* log(1-hypothesis);

sum_of_costs = sum( sum( costWhenYis1 - costWhenYis0 ) );

theta1Reg = Theta1(:, 2:end ); % Remove coefficients for bias
theta2Reg = Theta2(:, 2:end );
regularization = (lambda/(2*m)) * ( sum(sum( theta1Reg .^ 2 )) + sum(sum( theta2Reg .^ 2 )) );

J = (sum_of_costs / m) + regularization;

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.

% -- Unvectorized version
%    Delta1 = zeros(size(Theta1));
%    Delta2 = zeros(size(Theta2));
%    for k = 1:m
%        a1 = [1 X(k,:)]; % Add one as bias
%        z2 = (a1 * Theta1');
%        a2 = sigmoid(z2);
%    
%        a2 = [1 a2]; % Add one as bias
%        z3 = (a2 * Theta2');
%        a3 = sigmoid(z3);
%     
%        delta3 = a3 - yMatrix(k,:);
%        Delta2 = Delta2 + (delta3' * a2);
%        
%        delta2 = (delta3 * Theta2)(2:end) .* sigmoidGradient(z2);
%        Delta1 = Delta1 + (delta2' * a1);
%    endfor

% -- Vectorized version
delta3 = a3 - yMatrix;
Delta2 = (delta3' * a2);

delta2 = (delta3 * Theta2)(:,2:end) .* sigmoidGradient(z2);
Delta1 = (delta2' * a1);


% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

Theta1_reg = (lambda/m) * [zeros(size(Theta1,1),1) Theta1(:,2:end)];
Theta2_reg = (lambda/m) * [zeros(size(Theta2,1),1) Theta2(:,2:end)];

Theta1_grad = (Delta1) ./m + Theta1_reg;
Theta2_grad = (Delta2) ./m + Theta2_reg;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
