clear;
close all;

% load the data from given .mat file
load('signal_lab1.mat');

L = length(signal2);    % length of original signal

Nq = 100;       % Nyquist rate 100 Hz = 2 * max(8, 15, 50)

% 2 sampling rates
sampleRate_a = Nq/2;    % max(f1,f2,f3) = Nyquist rate/2
sampleRate_b = Nq;
% These are no. of intervals in each case
% These many no. of samples we need out of 1000
% we take 1 sample randomly from each interval

% size of interval from which we select sample
intervalSize_a = L / sampleRate_a;
intervalSize_b = L / sampleRate_b;


% iterating to find the variations in answer due to randomness
iterations = 100;

MSE_a = zeros(iterations, 1);
MSE_b = zeros(iterations, 1);

for iter = 1:iterations
    % non uniform sampling
    sample_a = zeros(1, sampleRate_a);
    index_a = zeros(1, sampleRate_a);
    for i = 1 : sampleRate_a
        index_a(i) = intervalSize_a * (i-1) + randi(intervalSize_a,1);
        sample_a(i) = signal2(index_a(i));
    end


    sample_b = zeros(1, sampleRate_b);
    index_b = zeros(1, sampleRate_b);
    for i = 1 : sampleRate_b
        index_b(i) = intervalSize_b * (i-1) + randi(intervalSize_b,1);
        sample_b(i) = signal2(index_b(i));
    end


    %%%%%%%%%%%%%% Part 3 Interpolating to get original signal %%%%%%%%%%%%%%%%


    % perform linear interpolation over sampled data in each case
    regen_a = interp1(index_a, sample_a, 1:L);
    regen_b = interp1(index_b, sample_b, 1:L);



    %%%%%%%%%%%%% computing reconstruction error %%%%%%%%%%%%%%

    % Here we are taking the error to be the mean squared error MSE
    totalError_a = 0;
    totalError_b = 0;

    % calculating the number of elements of array which have been interpolated
    % successfully and over which the error can be found out
    elem_a = 0;
    elem_b = 0;

    for i = 1:L 
        if ~isnan(regen_a(i))   % check if the interpolation has happened
            totalError_a = totalError_a + (signal2(i) - regen_a(i)) * (signal2(i) - regen_a(i));
            elem_a = elem_a + 1;
        end
    end

    MSE_a(iter) = totalError_a / elem_a;

    for i = 1:L
        if ~isnan(regen_b(i))
            totalError_b = totalError_b + (signal2(i) - regen_b(i)) * (signal2(i) - regen_b(i));
            elem_b = elem_b + 1;
        end
    end 

    MSE_b(iter) = totalError_b / elem_b;
    
end

MSE_uni_a = 0.8096;
MSE_uni_b = 0.0155;

figure
plot(1:iterations, MSE_uni_a-MSE_a)
title('Comparison of errors at sampling rate = Nyquist rate')
xlabel('Iterations')
ylabel('Error (MSE Uniform - MSE Non Uniform')

figure
plot(1:iterations, MSE_uni_b-MSE_b)
title('Comparison of errors at sampling rate = Nyquist rate')
xlabel('Iterations')
ylabel('Error (MSE Uniform - MSE Non Uniform')
