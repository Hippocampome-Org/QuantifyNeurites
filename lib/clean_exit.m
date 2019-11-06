function clean_exit()
    %% For record keeping, display in the command window the version of
    %   MATLAB being run.
    
    strng = sprintf('\nMATLAB Version %s.\nFinis.\n', version);
    disp(strng);
    clear
end