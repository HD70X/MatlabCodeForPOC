%C = readmatrix('PlayerAchievementData.xlsx');
prtBox = '|';
pdPT = 0;
fprintf('\n 读取数据');
C = readmatrix('PlayerAchievementEventData.csv','outputType','string');
Cs = size(C,1);
A = readmatrix('PlayerAchievementStockData.csv','outputType','string');
As = size(A,1);
S = readmatrix('Achievement.csv','outputType','string');
Ss = size(S,1);
fprintf('\n 编辑表头');
fid = fopen('PlayerAchievement.csv', 'w+', 'n', 'GB2312');
fprintf(fid, '%s,', 'PlayerID');
fprintf(fid, '%s,', 'ID');
fprintf(fid, '%s,', 'ACT');
for name = 1:61
    fprintf(fid, '%s,', S(name,2));
end
fprintf(fid, '%s,%s,%s,%s,%s,%s,%s,%s', '个人加成','永久成就点数','活跃分数','持有成就点数','核对活跃','核对持有','EIDRepeat','PIDRepeat');
fprintf(fid, '\n');
fprintf('\n 打印成就表 \n');
for i = 1 : Cs %检索序号为i的玩家
    bonues = 1;
    fprintf(fid, '%s,', C(i,2));
    fprintf(fid, '%s,', C(i,1));
    fprintf(fid, '%s,', C(i,3));
    EventID = zeros(1,61);
    for n= 1:61 %检索玩家第n个成就
        for m= 1:61
            if C(i,2*(n+1)) == S(m,1)
                if C(i,(2*(n+1)+1)) == '1'
                    EventID(1,m) = str2double(S(m,3));
                    if m == 11
                        bonues = bonues + str2double(S(m,4));
                    elseif m == 12
                        bonues = bonues + str2double(S(m,4));
                    elseif m == 13
                        bonues = bonues + str2double(S(m,4));
                    elseif m == 14
                        bonues = bonues + str2double(S(m,4));
                    end
                end
            end
        end
    end
    EventScore = 0;
    AchieScore = 0;
    for l= 1:61
        fprintf(fid, '%i,',EventID(1,l)); 
        if l<=9
            EventScore = EventScore + EventID(1,l);
        else
            AchieScore = AchieScore + EventID(1,l);
        end
    end   
    %数据核对
    Actp = 'EmptyData';
    CheckEv = 'NotMatch';
    CheckAc = 'NotMatch';
    for j = 1:As
        if C(i,2) == A(j,1)
            %Actp = 'FoundPID';
            Actp = A(j,11);
            if EventScore == str2double(A(j,5))
                CheckEv = 'Go';
            else
                CheckEv = append('NotMatch',' ',A(j,5));
            end
            if AchieScore == str2double(A(j,8))
                CheckAc = 'Go';
            else
                CheckAc = append('NotMatch',' ',A(j,8));
            end
        end
    end
    if strcmp(Actp, 'EmptyData') == 1
        for j = 1:As
            if C(i,1) == A(j,1)
                Actp = 'FoundEID';
                %Actp = A(j,11);
            end
        end
    end
    fprintf(fid, '%i,%s,%i,%i,%s,%s,',bonues,Actp,EventScore,AchieScore,CheckEv,CheckAc);
    %重复检测
    EventRepeat = 0;
    PlayerRepeat = 0;
    for repleyChieck = 1:Cs
        if C(i,2) == C(repleyChieck,2) && i ~= repleyChieck
            PlayerRepeat = PlayerRepeat+1;
            EventRepeat = EventRepeat+1;
        end
    end
    %进度
    fprintf(fid, '%i,%i,', EventRepeat, PlayerRepeat);
    fprintf(fid, '\n');
    pdPTNew = fix(i / Cs * 100);
    printPd = pdPTNew - pdPT;
    if printPd >= 1
        pdPT = pdPTNew;
        for prt = 1:printPd
            fprintf('%s', prtBox);
        end
    end
end
fclose(fid);
% G = readmatrix('PlayerAchievement.csv','outputType','string');
% Gs = size(G,1);
% TotalEvent = 0;
% for ach1 = 1:Gs
%     if  strcmp(G(ach1,66),'EmptyData') ~= 1
%         TotalEvent = TotalEvent + str2double(G(ach1,67));
%     end
% end
fprintf('\n 完成 \n');