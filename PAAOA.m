function [Best_FF,Best_P,Conv_curve]=PAAOA(N,M_Iter,LB,UB,Dim,F_obj)
%display('PAAOA Working');
%Two variables to keep the positions and the fitness value of the best-obtained solution

Best_P=zeros(1,Dim);
Best_FF=inf;
Conv_curve=zeros(1,M_Iter);
MOP_Max=1;
MOP_Min=0.2;

Mu_max=1;
Mu_min=0.1;
C_Iter=1;
Alpha=5;
Mu=0.499;
groups=4;
sizepop=N/groups;
%Initialize the positions of solution
for g=1:groups
    group(g).X=initialization(sizepop,Dim,UB,LB);
    group(g).Xnew=group(g).X;
    group(g).Ffun=zeros(1,size(group(g).X,1));% (fitness values)\
    group(g).Ffun_new=zeros(1,size(group(g).Xnew,1));
end

for g=1:groups
    for i=1:size(group(g).X,1)
        group(g).Ffun(1,i)=F_obj(group(g).X(i,:));  %Calculate the fitness values of solutions
    end
    [group(g).bestfun,group(g).bestindex]=min(group(g).Ffun);
    group(g).Ffungbest= group(g).bestfun;%最佳适应度值
    group(g).gbest=group(g).X(group(g).bestindex,:);
    if group(g).Ffungbest<Best_FF
        Best_FF=group(g).Ffungbest;
        Best_P=group(g).gbest;
    end
end
while C_Iter<M_Iter+1  %Main loop
    for g=1:groups
        %%
        for i=1:size(group(g).X,1)
            group(g).Ffun(1,i)=F_obj(group(g).X(i,:));
            f=group(g).Ffun(1,i);
            fmin=min(group(g).Ffun);
            fmax=max(group(g).Ffun);
            favg=(sum(group(g).Ffun))/size(group(g).X,1);
            if f<=favg
                Mu_1=Mu_min+(Mu_max-Mu_min)*[(f-fmin)/(favg-fmin)];
%                                 Mu_1=Mu_min+(Mu_max-Mu_min)*[(favg-f)/(fmax-fmin)];
            
            else
                Mu_1=Mu_max-(Mu_max-Mu_min)*[(fmax-f)/(fmax-favg)];
%                                 Mu_1=Mu_max-(Mu_max-Mu_min)*[(f-favg)/(fmax-fmin)];
            
            end
            Alpha=1-Mu_1+eps;
       
            MOP=1-((C_Iter)^(1/Alpha)/(M_Iter)^(1/Alpha));   % Probability Ratio
            MOA=MOP_Min+C_Iter*((MOP_Max-MOP_Min)/M_Iter); %Accelerated function
        end
        for i=1:size(group(g).X,1)   % if each of the UB and LB has a just value
            for j=1:size(group(g).X,2)
                r1=rand();
                if (size(LB,2)==1)
                    if r1>MOA
                        r2=rand();
                        if r2>0.5
                            group(g).Xnew(i,j)=Best_P(1,j)/(MOP+eps)*((UB-LB)*Mu+LB);
                        else
                            group(g).Xnew(i,j)=Best_P(1,j)*MOP*((UB-LB)*Mu+LB);
                        end
                    else
                        r3=rand();
                        if r3>0.5
                            group(g).Xnew(i,j)=Best_P(1,j)-MOP*((UB-LB)*Mu+LB);
                        else
                            group(g).Xnew(i,j)=Best_P(1,j)+MOP*((UB-LB)*Mu+LB);
                        end
                    end
                end
                
                
                if (size(LB,2)~=1)   % if each of the UB and LB has more than one value
                    r1=rand();
                    if r1>MOA
                        r2=rand();
                        if r2>0.5
                            group(g).Xnew(i,j)=Best_P(1,j)/(MOP+eps)*((UB(j)-LB(j))*Mu+LB(j));
                        else
                            group(g).Xnew(i,j)=Best_P(1,j)*MOP*((UB(j)-LB(j))*Mu+LB(j));
                        end
                    else
                        r3=rand();
                        if r3>0.5
                            group(g).Xnew(i,j)=Best_P(1,j)-MOP*((UB(j)-LB(j))*Mu+LB(j));
                        else
                            group(g).Xnew(i,j)=Best_P(1,j)+MOP*((UB(j)-LB(j))*Mu+LB(j));
                        end
                    end
                end
                
            end
            
            Flag_UB=group(g).Xnew(i,:)>UB; % check if they exceed (up) the boundaries
            Flag_LB=group(g).Xnew(i,:)<LB; % check if they exceed (down) the boundaries
            group(g).Xnew(i,:)=(group(g).Xnew(i,:).*(~(Flag_UB+Flag_LB)))+UB.*Flag_UB+LB.*Flag_LB;
            
            group(g).Ffun_new(1,i)=F_obj(group(g).Xnew(i,:));  % calculate Fitness function
            if group(g).Ffun_new(1,i)<group(g).Ffun(1,i)
                group(g).X(i,:)=group(g).Xnew(i,:);
                group(g).Ffun(1,i)=group(g).Ffun_new(1,i);
            end
            if group(g).Ffun(1,i)<Best_FF
                Best_FF=group(g).Ffun(1,i);
                Best_P=group(g).X(i,:);
            end
        end
        
        %%交流策略
        [group(g).bestfun,group(g).bestindex]=min(group(g).Ffun);
        group(g).Ffungbest= group(g).bestfun;%最佳适应度值
        group(g).gbest=group(g).X(group(g).bestindex,:);
        
        if rem(C_Iter,20)==0
            if rand <0.5
                % 随机选一个比较
                RG = randperm(groups,1);
                if group(g).Ffungbest > group(RG).Ffungbest
                    group(g).Ffungbest = group(RG).Ffungbest;
                    group(g).gbest = group(RG).gbest;
                else
                    group(RG).Ffungnest=group(g).Ffungbest;
                    group(RG).gbest=group(g).gbest;
                end
            else
                if group(g).Ffungbest > Best_FF
                    group(g).Ffungbest = Best_FF;
                    group(g).gbest = Best_P;
                end
            end
        end
    end
    %Update the Position of solutions
    
    
    %Update the convergence curve
    Conv_curve(C_Iter)=Best_FF;
    
    
    
    %Print the best solution details after every 50 iterations
    %     if mod(C_Iter,50)==0
    %         display(['At iteration ', num2str(C_Iter), ' the best solution fitness is ', num2str(Best_FF)]);
    %     end
    
    C_Iter=C_Iter+1;  % incremental iteration
    
end

