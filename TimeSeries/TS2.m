clear all; clc;
X = [1 2 3];
layerstructure = [4];
Theta = initTheta(X,layerstructure);
lambda = 0.8;
m = size(X,1);
s = 1;
t = 1000;
y = 0;
alpha = 0.001;

fprintf('Iterating...\n');

%  for iter = 1:t
    time = 0;
    BigDelta = initBigDelta(Theta);
    reward = [];

    for l = 1:s
        j = true;

        Position = rand()-0.5;
        Velocity = 0.0;
        height = 1 - cos(Position);


        while j == true
            time = time + 1;
            Action = randi([-1 1]);
            
            %(s{t},a{t}), (s{t+1},a{t+1}), ...
            thisX(time,:) = [Velocity Position Action]; % = [s,a], s = [Vel Pos]

            if height >= 0.8
                Velocity = - 0.3*Velocity;
            end

            Velocity = Velocity + (Action)*0.001 + cos(Position - pi/2)*(-0.0035);
            Position = Position + Velocity;
            height = 1 - cos(Position);
%             thisX(time,:) = [Velocity Position Action];
%             reward = -0.4 + height;
            
            if ((height >= 0.55) && (Position > 0))
                j = false;
                reward = [reward 0];
%             elseif (height >= 0.30) && (Position > 0)
%                 reward = [reward 70*height];

            else
                reward = [reward (-1 + height)];
            end
            
            if time == 1000
                j=false;
            end
                
        end
        fprintf('Iteration: %d\n', l);
    end    

    thisX(time,:) = [Velocity Position Action];
    
%   Q(s,a) = r + gamma*(max(a{t+1}Qn(s{t+1},a{t+1})))
%   1.1 (s,a) = thisX(1,:)
%   1.2 (s{t+1},a{t+1}) = [thisX(2,1:end-1) possibleAs] -> possibleAs
%           generated by nnCompute
%   2.1 (s,a) = thisX(2,:)
    

for iter = 1:t
    BigDelta = initBigDelta(Theta);  
    for j = 1:time-1
        thisInput = thisX(j,:); %(s,a)
        nextInput = thisX(j+1,1:end-1); %(s{t+1},a{t+1})
        r_imm = reward(j);
        
        [grad, BigDelta, a] = nnCompute(thisInput, nextInput, lambda, Theta, r_imm, BigDelta, alpha);        
    end
    
    for k = 1:length(grad)
            grad{k} = grad{k}*1/(time);
            Theta{k} = Theta{k} - grad{k};
    end
    
    

    for check = 1:15:iter*40
        if iter == check
            
            if (check-1)/15 >= 1
                check
                tth{(check-1)/15 +1} = Theta{1};
                tth1 = tth{(check-1)/15+1} - tth{(check-1)/15};
                disp(tth1);
            else
                tth{check} = Theta{1};
            end
            
            disp(Theta{2});
        end
    end
end

    %% Leave this for now...
    
%     for iter = 1:t
%         BigDelta = initBigDelta(Theta);    
%         for i = 1:time
%             [grad, BigDelta, aval, y] = nnCompute(thisX(i,:), lambda, Theta, reward(i), BigDelta, y, alpha);
%     %         pause(1);
%         end
% 
%         for k = 1:length(grad)
%             grad{k} = grad{k}*1/(time);
%             Theta{k} = Theta{k} - grad{k};
%         end
%         for check = 1:5:iter*s
%             if iter == check
%                 disp(Theta{1});
%                 disp(Theta{2});
%             end
%         end
%     end
%  
 
