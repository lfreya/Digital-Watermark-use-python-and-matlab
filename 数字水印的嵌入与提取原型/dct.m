function [watermrkd_img,recmessage,attack_image,attack_message,PSNR,NCC,MSSIM,PSNR_a,NCC_a,MSSIM_a] = dct(cover_object,message,height,width,var)

cover_object=reshape(cover_object,length(cover_object),length(cover_object),3);
message=reshape(message,height,width,3);
message1 =message;

mark=im2bw(message);    %ʹˮӡͼ���Ϊ��ֵͼ

marksize=size(mark);   %����ˮӡͼ��ĳ���
rm=marksize(1);      %rmΪˮӡͼ�������
cm=marksize(2);     %cmΪˮӡͼ�������

alpha=30;     %�߶�����,����ˮӡ��ӵ�ǿ��,������Ƶ��ϵ�����޸ĵķ���
k1=randn(1,8);  %����������ͬ���������
k2=randn(1,8);

yuv=rgb2ycbcr(cover_object);   %��RGBģʽ��ԭͼ���YUVģʽ
Y=yuv(:,:,1);    %�ֱ��ȡ���㣬�ò�Ϊ�ҶȲ�
U=yuv(:,:,2);      %��Ϊ�˶����ȵ����жȴ��ڶ�ɫ�ʵ����жȣ����ˮӡǶ��ɫ�ʲ���
V=yuv(:,:,3);

before=blkproc(U,[8 8],'dct2');   %������ͼ���ɫ�ʲ��Ϊ8��8��С�飬ÿһ��������άDCT�任������������before

after=before;   %��ʼ������ˮӡ�Ľ������
for i=1:rm          %����Ƶ��Ƕ��ˮӡ
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
result=blkproc(after,[8 8],'idct2');    %���������ͼ���Ϊ8��8��С�飬ÿһ��������άDCT��任
yuv_after=cat(3,Y,result,V);      %���������ɫ�ʲ������δ����Ĳ�ϳ�
rgb=ycbcr2rgb(yuv_after);    %ʹYUVͼ����RGBͼ��
watermrkd_img=rgb;


%��ȡˮӡ
withmark=uint8(rgb);
yuv2=rgb2ycbcr(withmark);   %��RGBģʽ��ԭͼ���YUVģʽ
U_2=yuv2(:,:,2);         %ȡ��withmarkͼ��ĻҶȲ�
after_2=blkproc(U_2,[8,8],'dct2');   %�˲���ʼ��ȡˮӡ�����ҶȲ�ֿ����DCT�任
p=zeros(1,8);        %��ʼ����ȡ��ֵ�õľ���
for i=1:marksize(1)
for j=1:marksize(2)
x=(i-1)*8;y=(j-1)*8;
p(1)=after_2(x+1,y+8);         %��֮ǰ�ı����ֵ�ĵ����ֵ��ȡ����
p(2)=after_2(x+2,y+7);
p(3)=after_2(x+3,y+6);
p(4)=after_2(x+4,y+5);
p(5)=after_2(x+5,y+4);
p(6)=after_2(x+6,y+3);
p(7)=after_2(x+7,y+2);
p(8)=after_2(x+8,y+1);
if corr2(p,k1)>corr2(p,k2)  %corr2����������������ƶȣ�Խ�ӽ�1���ƶ�Խ��
mark_2(i,j)=1;              %�Ƚ���ȡ��������ֵ�����Ƶ��k1��k2�����ƶȣ���ԭˮӡͼ��
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

%����
attack_image=attack(watermrkd_img,var);
% 
%��ȡ�������ˮӡ
attackmark=uint8(attack_image);
yuv3=rgb2ycbcr(attackmark);   %��RGBģʽ��ԭͼ���YUVģʽ
U_3=yuv3(:,:,2);         %ȡ��withmarkͼ��ĻҶȲ�
after_3=blkproc(U_3,[8,8],'dct2');   %�˲���ʼ��ȡˮӡ�����ҶȲ�ֿ����DCT�任
q=zeros(1,8);        %��ʼ����ȡ��ֵ�õľ���
for i=1:marksize(1)
for j=1:marksize(2)
x=(i-1)*8;y=(j-1)*8;
q(1)=after_3(x+1,y+8);         %��֮ǰ�ı����ֵ�ĵ����ֵ��ȡ����
q(2)=after_3(x+2,y+7);
q(3)=after_3(x+3,y+6);
q(4)=after_3(x+4,y+5);
q(5)=after_3(x+5,y+4);
q(6)=after_3(x+6,y+3);
q(7)=after_3(x+7,y+2);
q(8)=after_3(x+8,y+1);
if corr2(q,k1)>corr2(q,k2)  %corr2����������������ƶȣ�Խ�ӽ�1���ƶ�Խ�󣨲��Ǻܶ�Ϊʲô��k1,k2����������бȽϣ�
mark_3(i,j)=1;              %�Ƚ���ȡ��������ֵ�����Ƶ��k1��k2�����ƶȣ���ԭˮӡͼ��
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
