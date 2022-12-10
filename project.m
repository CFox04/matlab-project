clear all;
clc;

% Load csv data
data = readmatrix("channel_properties.csv");

ROWS = size(data, 1);
COLS = size(data, 2);

firstnum_input = input("First number in cross section designation: ");
secondnum_input = input("Second number in cross section designation: ");

% Find the row corresponding to the user's input
row = [];

for r = 1:1:ROWS
    firstnum = data(r, 1);
    secondnum = data(r, 2);

    if firstnum_input == firstnum && secondnum_input == secondnum
        row = data(r, 3:COLS);
        break;
    end
end

designation = sprintf('C%s X %s', num2str(firstnum_input), num2str(secondnum_input));

% If row was not found show an error and end the program
if isempty(row)
    fprintf("Designation '%s' is invalid!\n", designation);
    return
end

fprintf("Full Designation: %s\n", designation);

% Get variables from row
b_f = row(1, 3);
d = row(1, 2);
t_f = row(1, 4);
t_w = row(1, 5);

% Run calculations
n1 = (b_f - t_w);
n2 = (d - 2 * t_f);
n3 = (b_f^2 * d) / 2;

A = b_f * d - n1 * n2;
x = ( n3 - n1 * n2 * ( t_w + n1 / 2) ) / A;
I_x = ((b_f * d^3) / 12) - (n1 * n2^3) / 12;
S_x = (2 * I_x) / d;
r_x = sqrt(I_x / A);
I_y = ((b_f^3 *d) / 12) + ((b_f * d) * ((b_f / 2) - x)^2) - ((n1^3 * n2) / 12) - (n1 * n2 * (t_w + (n1/2) - x)^2);
c = b_f - x;
S_y = I_y / c;
r_y = sqrt((I_y)/A);

A_actual = row(1, 1);
x_actual = row(1, 12);
I_x_actual = row(1, 6);
S_x_actual = row(1, 7);
r_x_actual = row(1, 8);
I_y_actual = row(1, 9);
S_y_actual = row(1, 10);
r_y_actual = row(1, 11);

% Calculate percentage error
A_error = percent_error(A_actual, A);
x_error = percent_error(x_actual, x);
I_x_error = percent_error(I_x_actual, I_x);
S_x_error = percent_error(S_x_actual, S_x);
r_x_error = percent_error(r_x_actual, r_x);
I_y_error = percent_error(I_y_actual, I_y);
S_y_error = percent_error(S_y_actual, S_y);
r_y_error = percent_error(r_y_actual, r_y);

% Display data
A_col = [A; A_actual; A_error];
I_x_col = [I_x; I_x_actual; I_x_error];  
S_x_col = [S_x; S_x_actual; S_x_error];
r_x_col = [r_x; r_x_actual; r_x_error];
I_y_col = [I_y; I_y_actual; I_y_error];
S_y_col = [S_y; S_y_actual; S_y_error];
r_y_col = [r_y; r_y_actual; r_y_error];
x_col = [x; x_actual; x_error];

t = table(A_col, I_x_col, S_x_col, r_x_col, I_y_col, S_y_col, r_y_col, x_col);

title = sprintf("Property calculation results for designation '%s'", designation);

fig = uifigure;
fig.Name = title;

% Position in center and take up 1/2 of screen
fig.Units = "normalized";
fig.Position = [0.5 0.5 0.5 0.5];

uit = uitable(fig, 'Data', t);

% Position in center and fill entire figure
uit.Units = "normalized";
uit.Position = [0 0 1 1];

uit.ColumnName = ["A", "I_x", "S_x", "r_x", "I_y", "S_y", "r_y", "x"];
uit.RowName = ["Calculated", "Actual", "Percent Error"];
