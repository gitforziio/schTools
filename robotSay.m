function [count,obj]=robotSay(varargin)
% robotSay([fid,] robotName, format, A ...)
%

global RobotCanSay;

if RobotCanSay
    
    fidDefult       = 1       ;
    robotNameDefult = 'ROBOT' ;
    sayingDefult    = ' '  ;
    
    s=varargin;
    l=length(s);
    
    if l==0
        situation='empty';
    elseif ischar(s{1})
        situation='robot';
    elseif isnumeric(s{1})
        situation='fid';
    else
        situation='error';
    end
    
    switch situation
        case 'error'
            error('Uncorrect input.');
        case 'empty'
            fid         =  fidDefult       ;
            robotName   =  robotNameDefult ;
            saying      =  sayingDefult    ;
            A           =  {[]}              ;
        case 'robot'
            if l<3
                for i = (l+1):3
                    s{i}=[];
                end
            end
            fid         =  fidDefult       ;
            robotName   =  betterOne(robotNameDefult,s{1}) ;
            saying      =  betterOne(sayingDefult,s{2})    ;
            A           =  s(3:end)        ;
        case 'fid'
            if l<4
                for i = (l+1):4
                    s{i}=[];
                end
            end
            fid         =  s{1}            ;
            robotName   =  betterOne(robotNameDefult,s{2}) ;
            saying      =  betterOne(sayingDefult,s{3})    ;
            A           =  s(4:end)        ;
    end
    
    wordstosay=['%s: ',saying,'  \n'];
    if isempty(A{1})
        count=fprintf(fid,wordstosay,robotName);
    else
        count=fprintf(fid,wordstosay,robotName,A{:});
    end
    
    obj.fid=fid;
    obj.robotName=robotName;
    obj.saying=saying;
    obj.A=A;
    obj.state='Robot can say.';
    
else
    count=0;
    obj.fid=2;
    obj.robotName='';
    obj.saying='';
    obj.A={[]};
    obj.state='Robot can not say!';
end

end

function o=betterOne(a,b)
if isempty(b)
    o=a;
else
    o=b;
end
end

