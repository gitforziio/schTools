function alldir( dir_path )

    function printname=pn(d)
        if d.isdir
            printname = [d.name,'.dir'];
        else
            printname = d.name;
        end
    end


global RobotCanSay;
if isempty(RobotCanSay)
    RobotCanSay=0;
end

%RobotCanSay=1;

fid = fileSaverOpen( ['ptbptbptb','.log'], 'dir_log' );

fprintf('\n\nbegin, please wait...\n\n');

maindir = dir( dir_path );

for i=1:length(maindir)
    if strcmp(maindir(i).name(1), '.')==0
        fprintf(fid,'\n- %s\n', pn(maindir(i)));
    end
    if ( maindir(i).isdir && strcmp(maindir(i).name, '.')==0 && strcmp(maindir(i).name, '..')==0 )
        subdir = dir( fullfile(dir_path, maindir(i).name) );
        for j=1:length(subdir)
            if strcmp(subdir(j).name(1), '.')==0
                fprintf(fid,'- %s\n', fullfile(maindir(i).name, pn(subdir(j))));
                %fprintf('    - %s\n', subdir(j).name);
            end
            if ( subdir(j).isdir && strcmp(subdir(j).name, '.')==0 && strcmp(subdir(j).name, '..')==0 )
                subsubdir = dir( fullfile(dir_path, maindir(i).name, subdir(j).name) );
                for k=1:length(subsubdir)
                    if strcmp(subsubdir(k).name(1), '.')==0
                        fprintf(fid,'- %s\n', fullfile(maindir(i).name, subdir(j).name, pn(subsubdir(k))));
                        %fprintf('        - %s\n', subsubdir(k).name);
                    end
                end
            end
        end
    end
end

fprintf('\n\ndone!\n\n');

fileSaverClose(fid);

end
