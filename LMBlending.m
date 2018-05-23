function OUT = LMBlending(baseimage,unregistered,corners1,corners2)
t_concord = cp2tform(corners2,corners1,'projective');
% t_concord1 = fitgeotrans(corners2,corners1,'projective');
info.Height = max([size(unregistered,1),size(baseimage,1)]);
info.Width = max([size(unregistered,2),size(baseimage,2)]);
dH = round(info.Height/2);
dW = round(info.Width/2);
% unregisteredzeros =im2uint8(zeros(info.Height * 2 + 1,info.Width * 2 + 1,3));
% for i = dH+1 : dH*3
%     for j = dW+1 : dW*3
%         unregisteredzeros(i,j,:) = unregistered(i-dH,j-dW,:);
%     end
% end
figure;
registered = imtransform(unregistered,t_concord, 'nearest','XData',[-dW info.Width*1.5], 'YData',[-dH info.Height*1.5]);
imshow(registered);
% registered1 = imwarp(unregistered,t_concord1,'bilinear');
f1 = sum(registered(:,:,1));
f2 = sum(registered(:,:,1)');
T1 = find(f1>1);T2 = find(f2>1);
Dleft = T1(1);Dright = T1(end);
Dup   = T2(1);Ddown  = T2(end);
%%
info.Height = min([size(unregistered,1),size(baseimage,1)]);
info.Width = min([size(unregistered,2),size(baseimage,2)]);
dH = round(info.Height/2);
dW = round(info.Width/2);
for row=1:info.Height
    for col=1:info.Width
        if(registered(row+dH,col+dW,1)~=0)
            dx = info.Height - row;dy   = info.Width - col;
            dHmin = min(dx,row);  dWmin = min(dy,col);
            Dmin1 = min(dWmin,dHmin);
            Dx = min(row+dH-Dup,Ddown - row-dH);Dy = min(col+dW - Dleft,Dright - col-dW);
            Dmin2 = min(Dx,Dy);   
            temp0= (Dmin1+Dmin2);
             k1 = double(Dmin2/temp0);
             k2 = double(Dmin1/temp0);
            registered(row+dH,col+dW,:) =  double(registered(row+dH,col+dW,:)*k1+baseimage(row,col,:)*k2);
        else
            registered(row+dH,col+dW,:) = double(baseimage(row,col,:));
        end
    end
end
f1 = sum(registered(:,:,1));
f2 = sum(registered(:,:,1)');
T1 = find(f1>1);T2 = find(f2>1);
OUT = registered(T2(1):T2(end),T1(1):T1(end),:);

