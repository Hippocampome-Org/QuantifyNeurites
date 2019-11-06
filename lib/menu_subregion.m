function subregion = menu_subregion()

    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        %% display menu %%
        
        clc;
        
        strng = sprintf('Please enter a selection from the menu below ');
        disp(strng);
        
        disp('         1) Dentate Gyrus (DG)');
        
        disp('         2) CA3');
        
        disp('         3) CA2');

        disp('         4) CA1');

        disp('         5) Subiculum (Sub)');

        disp('         6) Entorhinal Cortex (EC)');

        reply = lower(input('\nYour selection: ', 's'));
        
        switch reply
            
            case '1' % DG
                subregion = {'DG'};
                reply = [];

            case '2' % CA3
                subregion = {'CA3'};
                reply = [];

            case '3' % CA2
                subregion = {'CA2'};
                reply = [];

            case '4' % CA1
                subregion = {'CA1'};
                reply = [];

            case '5' % Sub
                subregion = {'Sub'};
                reply = [];

            case '6' % EC
                subregion = {'EC'};
                reply = [];
                
            otherwise
                reply = [];
                
        end % switch
        
    end % while loop

end % menu_subregion()