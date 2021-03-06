function [node_coords,incidences,excavations] = TextFileInput(address)
    
    inputfile = fopen(address);

    startStringNodes = 'BEGIN_NODES'; 
    endStringNodes = 'BEGIN_EDGES';
    foundNodeList=false; %boolean to mark that the line "BEGIN_NODES" in the text file has been stored in tline

    startStringIncidences = 'BEGIN_ELEMENTS'; 
    endStringIncidences = 'BEGIN_MATERIALS';
    foundIncidences=false;
    
    startStringExcavations = 'BEGIN_EXCAVATIONS';
    foundExcavations=false;
    
    x=[]; y=[]; a=[]; b=[]; c=[]; excavations=[];

    while 1
        tline = fgetl(inputfile);

        %if the previous line contained startString, begin reading in and storing node coordinates
        if foundNodeList 
            %break if we hit end of file, the end string marker, or a blank line
            %should hit a blank line
            if ~ischar(tline)  ||  strcmp(tline, endStringNodes) || strcmp(tline,'')
                foundNodeList=false; %node list is complete
            else
                values=textscan(tline,'%f%f%f','delimiter','\t');
                x=[x; values{2}];
                y=[y; values{3}];
            end
        elseif foundIncidences
            if ~ischar(tline)  ||  strcmp(tline, endStringIncidences) || strcmp(tline,'')
                foundIncidences=false; %node list is complete
                %break
            else
                values=textscan(tline,'%f%s%s%s%f%f%f%f%f%f','delimiter','\t');
                a=[a; values{5}];
                b=[b; values{6}];
                c=[c; values{7}];
            end
%         elseif foundBC
%             if ~ischar(tline)  ||  strcmp(tline, endStringBC) || strcmp(tline,'')
%                 %foundBC=false; %BC list is complete
%                 break
%             else
%                 values=textscan(tline,'%f%s%f%s%f','delimiter','\t');
%                 if strcmp(values{4},'DX')
%                     %BC_xdis=[BC_xdix(:,1) values{3}; BC_xdix(:,2) values{5}]
%                     BC_xn=[BC_xn; values{3}];
%                     BC_xdis=[BC_xdis; values{5}];
%                 elseif strcmp(values{4},'DY')
%                     %BC_ydis=[BC_ydix(:,1) values{3}; BC_ydix(:,2) values{5}]
%                     BC_yn=[BC_yn; values{3}];
%                     BC_ydis=[BC_ydis; values{5}];
%                 end
%             end
        elseif foundExcavations
            if ~ischar(tline)%excavations list is complete
                foundExcavations=false; 
            else
                values=textscan(tline,'%f%f%f','delimiter','\t');
                excavations=[excavations;values{1},values{2},values{3}];
               %{ 
                %populate a 3D matrix of excavation boundary coordinates
                    %x by y by excavation#
                lastExcNum=excNum;
                excNum=values{1};
                if excNum~=lastExcNum
                    r=1;
                end
                excavations(r,:,excNum)=[values{2}, values{3}];
                r=r+1;
                %}
            end
        end

        %Test to begin storing node coordinates
        if strcmp(tline, startStringNodes)
            foundNodeList=true;
        %Test to begin storing element node IDs (indicence list)
        elseif strcmp(tline, startStringIncidences)
            foundIncidences=true;
%         elseif strcmp(tline, startStringBC)
%             foundBC=true;
        elseif strcmp(tline,startStringExcavations)
            foundExcavations=true;
            %excavations=[];%initialize the excavations matrix
            %r=1;
            %excNum=0;
        end
        
        
        
        % Break if we hit end of file
        if ~ischar(tline)
            break
        end
    end

    node_coords = [x y];
    incidences = [a b c];
%     BC_dx = [BC_xn BC_xdis];
%     BC_dy = [BC_yn BC_ydis];
    fclose(inputfile);
    
end