
for iteration = 1:10
    best=0;
    bestz=0;
    bestp=0;
    bestq=0;
    for z=2:45
        for p=2:z
            for q=2:p
                
                net = patternnet([z p q]);
                [net,tr] = train(net,x,t);
                
                
                y=net(x);
                
                
                [~,n] = size(x);
                count = 0; %overall dataset
                rec1=0;
                rec2=0;
                rec3=0;
                
                
                
                
                test =0;
                test1=0;
                good=0;
                bad=0;
                
                for i=1:n
                    y(i) = round(y(i));
                    
                    
                    if r(i)==3
                        if y(i)==y(i-1) && y(i-1)==y(i-2)
                            test=test+1;
                            if t(i)==y(i)
                                good=good+1;
                            end
                            if t(i)~=y(i)
                                bad=bad+1;
                            end
                        end
                        
                        if y(i)==y(i-1) && y(i)~=y(i-2)
                            %y(i-2)=y(i);
                            test1=test1+1;
                        end
                        if y(i)~=y(i-1) && y(i)==y(i-2)
                            %y(i-1)=y(i);
                            test1=test1+1;
                        end
                        if y(i-1)==y(i-2) && y(i)~=y(i-2)
                            %y(i)=y(i-1);
                            test1=test1+1;
                        end
                        
                        
                        
                        
                        if t(i)==y(i)
                            count=count+1;
                            rec1=rec1+1;
                        end
                        if t(i-1)==y(i-1)
                            count=count+1;
                            rec2=rec2+1;
                        end
                        if t(i-2)==y(i-2)
                            count=count+1;
                            rec3=rec3+1;
                        end
                        
                    end
                    
                    
                    
                end
                
                
                %disp('Number of Correct Units: ');
                %disp(count);
                %disp('Number of Incorrect Units: ');
                %disp(n- count);
                
                
                %disp('Number of Correct Diagnosis(1): ');
                %disp(rec1);
                %disp('Number of Incorrect Diagnosis(1): ');
                %disp(80- rec1);
                %disp('Number of Correct Diagnosis(2): ');
                %disp(rec2);
                %disp('Number of Incorrect Diagnosis(2): ');
                %disp(80- rec2);
                %disp('Number of Correct Diagnosis(3): ');
                %disp(rec3);
                %disp('Number of Incorrect Diagnosis(3): ');
                %disp(80- rec3);
                
                count=count*100;
                count=count/n;
                rec1=rec1*100;
                rec1=rec1/80;
                rec2=rec2*100;
                rec2=rec2/80;
                rec3=rec3*100;
                rec3=rec3/80;
                
                %disp('% Correct Classification (FULL) :');
                %disp(count);
                if count > best
                    best= count;
                    bestz=z;
                    bestp=p;
                    bestq=q;
                end
                
                %disp('% Correct Classification (1) :');
                %disp(rec1);
                %disp('% Correct Classification (2) :');
                %disp(rec2);
                %disp('% Correct Classification (3) :');
                %disp(rec3);
                
                [m,n] = size(tr.time);
                
                timelength =tr.time(n);
                
                %disp('All 3 Recordings matched: ');
                %disp(test);
                %disp('All 3 Recordings matched and Correct: ');
                %disp(good);
                %disp('All 3 Recordings matched and incorrect: ');
                %disp(bad);
                %disp('Accuracy within coherant results: ');
                %disp(good/test);
                
                timeavg = timelength/n;
                %disp('Time: ');
                %disp(timelength);
                %disp('Avg Time: ');
                %disp(timeavg);
            end
        end
    end
    
    
    disp('Best: ');
    disp(best);
    
    disp('BestZ: ');
    disp(bestz);
    disp('BestP: ');
    disp(bestp);
    disp('BestQ: ');
    disp(bestq);
end
