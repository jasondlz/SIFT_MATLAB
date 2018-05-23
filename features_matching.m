% 基于欧式距离的特征粗匹配
function des_num = features_matching( des1,des2,dist_ratio )
des_num = zeros(size(des1,1),2);
des_num(:,1) = 1:size(des1,1);
for num = 1:size(des1,1)
    dist = zeros(size(des2,1),1);
    for k = 1:size(des2,1)
        dist(k) = sqrt(sum((des1(num,:)-des2(k,:)).^2));
    end
    [mindist,minnum] = min(dist);
    dist(minnum) = max(dist);
    min2dist = min(dist);
    if mindist / min2dist < dist_ratio
        des_num(num,2) = minnum;
    end    
end

end


%pos2是按照顺序来的，POS1是检索后的结果