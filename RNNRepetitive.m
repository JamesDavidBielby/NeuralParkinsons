best=0;
average=0;
mean=0; %rolling average
squarediff=0;
sumsquarediff=0;
tp=0;
tn=0;
fp=0;
fn=0;
avgtp=0;
avgtn=0;
avgfp=0;
avgfn=0;
runs=5;
storageRNN(1,1)="count";
storageRNN(1,2)="tp";
storageRNN(1,3)="tn";
storageRNN(1,4)="fp";
storageRNN(1,5)="fn";
storageRNN(1,6)="Coherent Results";
storageRNN(1,7)="Correct Coherency";
storageRNN(1,8)="Void Units";
storageRNN(1,9)="Epochs";
fails=0;
for z=1:runs
    
    
    
    
    lrnn = layrecnet(1,10);
    lrnn.trainFcn = 'trainbr';
    
    
    
    lrnn.trainParam.epochs = 500;
    [lrnn,tr] = train(lrnn,x,t);
    
    y = lrnn(x);
    
    [~,n] = size(x);
    count = 0; %overall dataset
    rec1=0;
    rec2=0;
    rec3=0;
        
    tp=0;
    tn=0;
    fp=0;
    fn=0;
    
    
    test =0;
    test1=0;
    good=0;
    bad=0;
    void=0;
    
    voidind(240)=0;
    
    for i=1:n
        currentvoid=0;
        if y(i)>0.4 && y(i)<0.6
            void=void+1;
            voidind(void)=i;
            
        end
        
        y(i) = round(y(i));
        
         if y(i)>1
            y(i)=1;
        end
        if y(i)<0
            y(i)=0;
        end
        
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
    
    for i=1:240
         if y(i)>1
            y(i)=1;
        end
        if y(i)<0
            y(i)=0;
        end
        if t(i)==y(i)&& y(i)==1
            tp=tp+1;
        end
        if t(i)==y(i)&& y(i)==0
            tn=tn+1;
        end
        if t(i)~=y(i)&& y(i)==1
            fp=fp+1;
        end
        if t(i)~=y(i)&& y(i)==0
            fn=fn+1;
        end
    end
    
    disp('Number of Correct Units: ');
    disp(count);
    disp('Number of Incorrect Units: ');
    disp(n- count);
    disp('Number of void Units: ');
    disp(void);
    
    disp('Number of Correct Diagnosis(1): ');
    disp(rec1);
    disp('Number of Incorrect Diagnosis(1): ');
    disp(80- rec1);
    disp('Number of Correct Diagnosis(2): ');
    disp(rec2);
    disp('Number of Incorrect Diagnosis(2): ');
    disp(80- rec2);
    disp('Number of Correct Diagnosis(3): ');
    disp(rec3);
    disp('Number of Incorrect Diagnosis(3): ');
    disp(80- rec3);
    
    count=count*100;
    count=count/n;
    rec1=rec1*100;
    rec1=rec1/80;
    rec2=rec2*100;
    rec2=rec2/80;
    rec3=rec3*100;
    rec3=rec3/80;
    
    storageRNN(1+z,1)=(tp+tn)/(tp+tn+fp+fn);
    storageRNN(1+z,2)=tp;    
    storageRNN(1+z,3)=tn;
    storageRNN(1+z,4)=fp;
    storageRNN(1+z,5)=fn;
    
    disp('% Correct Classification (FULL) :');
    disp(count);
    
    if count > best
        best= count;
    end
    standard(z)=count/100;
    
    
    average=average+count;
    mean = average/z;
    squarediff=(count-mean)*(count-mean);
    sumsquarediff=sumsquarediff+squarediff;
    
    avgtp=avgtp+tp;
    avgtn=avgtn+tn;
    avgfp=avgfp+fp;
    avgfn=avgfn+fn;
    
    disp('% Correct Classification (1) :');
    disp(rec1);
    disp('% Correct Classification (2) :');
    disp(rec2);
    disp('% Correct Classification (3) :');
    disp(rec3);
    
    
    
    disp('All 3 Recordings matched: ');
    disp(test);
    storageRNN(1+z,6)=test;
    storageRNN(1+z,7)=good;
    storageRNN(1+z,8)=void;
    [~,iter] = size(tr.epoch);
    storageRNN(1+z,9)=iter-1;
    disp('All 3 Recordings matched and Correct: ');
    disp(good);
    disp('All 3 Recordings matched and incorrect: ');
    disp(bad);
    disp('Accuracy within coherant results: ');
    disp(good/test);
    disp('Run: ');
    disp(z);
    if count == 50      
        disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
        disp('there has been an error');
        disp(z);
        disp('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');    
        
    end
    
end
avgtp=avgtp/runs;
avgtn=avgtn/runs;
avgfp=avgfp/runs;
avgfn=avgfn/runs;
stddev=std(standard);
accuracy = (avgtp+avgtn)/(avgtp+avgtn+avgfp+avgfn);
sensitivity = avgtp/(avgtp+avgfn);
specificity=avgtn/(avgtn+avgfp); %recall
precision = avgtp/(avgtp+avgfp);
disp('Avg: ');
disp(average/runs);
disp('StdDev: ');
disp(stddev);
disp('Best: ');
disp(best);
disp('Accuracy: ');
disp(accuracy);
disp('Sensitivity: ');
disp(sensitivity);
disp('Specificity (Recall): ');
disp(specificity);
disp('Precision): ');
disp(precision);
