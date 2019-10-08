function [watermrkd_img,recmessage,attack_image,attack_message,PSNR,NCC,MSSIM,PSNR_a,NCC_a,MSSIM_a] = dct(cover_object,message,height,width,var)

cover_object=reshape(cover_object,length(cover_object),length(cover_object),3);
message=reshape(message,height,width,3);
message1 =message;

mark=im2bw(message);    %使水印图像变为二值图

marksize=size(mark);   %计算水印图像的长宽
rm=marksize(1);      %rm为水印图像的行数
cm=marksize(2);     %cm为水印图像的列数

alpha=30;     %尺度因子,控制水印添加的强度,决定了频域系数被修改的幅度
k1=randn(1,8);  %产生两个不同的随机序列
k2=randn(1,8);

yuv=rgb2ycbcr(cover_object);   %将RGB模式的原图变成YUV模式
Y=yuv(:,:,1);    %分别获取三层，该层为灰度层
U=yuv(:,:,2);      %因为人对亮度的敏感度大于对色彩的敏感度，因此水印嵌在色彩层上
V=yuv(:,:,3);

before=blkproc(U,[8 8],'dct2');   %将载体图像的色彩层分为8×8的小块，每一块内做二维DCT变换，结果记入矩阵before

after=before;   %初始化载入水印的结果矩阵
for i=1:rm          %在中频段嵌入水印
    for j=1:cm
        x=(i-1)*8;
        y=(j-1)*8;
        if mark(i,j)==1
            k=k1;
        else
            k=k2;
        end
        after(x+1,y+8)=before(x+1,y+8)+alpha*k(1);
        after(x+2,y+7)=before(x+2,y+7)+alpha*k(2);
        after(x+3,y+6)=before(x+3,y+6)+alpha*k(3);
        after(x+4,y+5)=before(x+4,y+5)+alpha*k(4);
        after(x+5,y+4)=before(x+5,y+4)+alpha*k(5);
        after(x+6,y+3)=before(x+6,y+3)+alpha*k(6);
        after(x+7,y+2)=before(x+7,y+2)+alpha*k(7);
        after(x+8,y+1)=before(x+8,y+1)+alpha*k(8);
    end
end
result=blkproc(after,[8 8],'idct2');    %将经处理的图像分为8×8的小块，每一块内做二维DCT逆变换
yuv_after=cat(3,Y,result,V);      %将经处理的色彩层和两个未处理的层合成
rgb=ycbcr2rgb(yuv_after);    %使YUV图像变回RGB图像
watermrkd_img=rgb;


%提取水印
withmark=uint8(rgb);
yuv2=rgb2ycbcr(withmark);   %将RGB模式的原图变成YUV模式
U_2=yuv2(:,:,2);         %取出withmark图像的灰度层
after_2=blkproc(U_2,[8,8],'dct2');   %此步开始提取水印，将灰度层分块进行DCT变换
p=zeros(1,8);        %初始化提取数值用的矩阵
for i=1:marksize(1)
for j=1:marksize(2)
x=(i-1)*8;y=(j-1)*8;
p(1)=after_2(x+1,y+8);         %将之前改变过数值的点的数值提取出来
p(2)=after_2(x+2,y+7);
p(3)=after_2(x+3,y+6);
p(4)=after_2(x+4,y+5);
p(5)=after_2(x+5,y+4);
p(6)=after_2(x+6,y+3);
p(7)=after_2(x+7,y+2);
p(8)=after_2(x+8,y+1);
if corr2(p,k1)>corr2(p,k2)  %corr2计算两个矩阵的相似度，越接近1相似度越大
mark_2(i,j)=1;              %比较提取出来的数值与随机频率k1和k2的相似度，还原水印图样
else
mark_2(i,j)=0;
end
end
end

% read in original watermark
orig_watermark=double(message);
 
% determine size of original watermark
Mo=size(orig_watermark,1);  %Height
No=size(orig_watermark,2);  %Width

message_vector=mark_2;
recmessage=reshape(message_vector,Mo,No);

%攻击
attack_image=attack(watermrkd_img,var);
% 
%提取攻击后的水印
attackmark=uint8(attack_image);
yuv3=rgb2ycbcr(attackmark);   %将RGB模式的原图变成YUV模式
U_3=yuv3(:,:,2);         %取出withmark图像的灰度层
after_3=blkproc(U_3,[8,8],'dct2');   %此步开始提取水印，将灰度层分块进行DCT变换
q=zeros(1,8);        %初始化提取数值用的矩阵
for i=1:marksize(1)
for j=1:marksize(2)
x=(i-1)*8;y=(j-1)*8;
q(1)=after_3(x+1,y+8);         %将之前改变过数值的点的数值提取出来
q(2)=after_3(x+2,y+7);
q(3)=after_3(x+3,y+6);
q(4)=after_3(x+4,y+5);
q(5)=after_3(x+5,y+4);
q(6)=after_3(x+6,y+3);
q(7)=after_3(x+7,y+2);
q(8)=after_3(x+8,y+1);
if corr2(q,k1)>corr2(q,k2)  %corr2计算两个矩阵的相似度，越接近1相似度越大（不是很懂为什么和k1,k2两个随机序列比较）
mark_3(i,j)=1;              %比较提取出来的数值与随机频率k1和k2的相似度，还原水印图样
else
mark_3(i,j)=0;
end
end
end


% 
% read in original watermark
orig_watermark=double(message);
 
% determine size of original watermark
Mo=size(orig_watermark,1);  %Height
No=size(orig_watermark,2);  %Width

message_vector2=mark_3;
attack_message=reshape(message_vector2,Mo,No);


% convert back to uint8
watermarked_image_uint8=uint8(watermrkd_img);

% calculate the PSNR
I0     = double(cover_object);
I1     = double(watermarked_image_uint8);
Id     = (I0-I1);
signal = sum(sum(I0.^2));
noise  = sum(sum(Id.^2));
MSE  = noise./numel(I0);
peak = max(I0(:));
PSNR = 10*log10(peak^2/MSE(:,:,1));

% calculate the PSNR_a
A0=double(watermarked_image_uint8);
A1=double(attack_image);
Ad=(A0-A1);
signal_a = sum(sum(A0.^2));
noise_a  = sum(sum(Ad.^2));
MSE_a  = noise_a./numel(A0);
peak_a = max(A0(:));
PSNR_a = 10*log10(peak_a^2/MSE_a(:,:,1));


%Normalized Cross Correlation
NCC=nc(double(message1),recmessage);
% NCC=single(Ncc);
% NCC_a
NCC_a=nc(double(message1),attack_message);
% NCC_a=single(Ncc_a);

% calculate the SSIM
MSSIM=ssim(cover_object,watermrkd_img);
% MSSIM_a
MSSIM_a=ssim(watermrkd_img,attack_image);

end
