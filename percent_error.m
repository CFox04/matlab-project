function error_string = percent_error(actual, calculated)
    error = abs(round((((actual - calculated) / actual) * 100), 2));
    error_string = string(error) + "%";
end
