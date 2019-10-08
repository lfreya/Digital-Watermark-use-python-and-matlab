function [watermrkd_img,recmessage,attack_image,attack_message,PSNR,NCC,MSSIM,PSNR_a, NCC_a, MSSIM_a] = dwt(cover_object,message,height,width,var)

cover_object=reshape(cover_object,length(cover_object),length(cover_object),3);
message=reshape(message,height,width,3);
message1 =message;

 %嵌入水印
input=cover_object;
water=message;

%三色分离
input=double(input);
water=double(water);
inputr=input(:,:,1);
waterr=water(:,:,1);
inputg=input(:,:,2);
waterg=water(:,:,2);
inputb=double(input(:,:,3));
waterb=double(water(:,:,3));
%系数r 大，鲁棒性增加，r小，透明性增加
r=0.04;
%水印R的分解
[Cwr,Swr]=wavedec2(waterr,1,'haar');
%图像R的分解
[Cr,Sr]=wavedec2(inputr,2,'haar');
%水印的嵌入
Cr(1:size(Cwr,2)/16)=Cr(1:size(Cwr,2)/16)+r*Cwr(1:size(Cwr,2)/16);
k=0;
while k<=size(Cr,2)/size(Cwr,2)-1
       Cr(1+size(Cr,2)/4+k*size(Cwr,2)/4:size(Cr,2)/4+...
               (k+1)*size(Cwr,2)/4)=Cr(1+size(Cr,2)/4+...
               k*size(Cwr,2)/4:size(Cr,2)/4+(k+1)*size(Cwr,2)/4)+...
               r*Cwr(1+size(Cwr,2)/4:size(Cwr,2)/2);
       Cr(1+size(Cr,2)/2+k*size(Cwr,2)/4:size(Cr,2)/2+...
               (k+1)*size(Cwr,2)/4)=Cr(1+size(Cr,2)/2+...
               k*size(Cwr,2)/4:size(Cr,2)/2+(k+1)*size(Cwr,2)/4)+...
               r*Cwr(1+size(Cwr,2)/2:3*size(Cwr,2)/4);
       Cr(1+3*size(Cr,2)/4+k*size(Cwr,2)/4:3*size(Cr,2)/4+...
               (k+1)*size(Cwr,2)/4)=Cr(1+3*size(Cr,2)/4+...
               k*size(Cwr,2)/4:3*size(Cr,2)/4+(k+1)*size(Cwr,2)/4)+...
               r*Cwr(1+3*size(Cwr,2)/4:size(Cwr,2));
       k=k+1;
end
Cr(1:size(Cwr,2)/4)=Cr(1:size(Cwr,2)/4)+r*Cwr(1:size(Cwr,2)/4);
g=0.02;
%水印G的分解
[Cwg,Swg]=wavedec2(waterg,1,'haar');
%图像G的分解
[Cg,Sg]=wavedec2(inputg,2,'haar');
%水印的嵌入
Cg(1:size(Cwg,2)/16)=Cg(1:size(Cwg,2)/16)+g*Cwg(1:size(Cwg,2)/16);
k=0;
while k<=size(Cg,2)/size(Cwg,2)-1
       Cg(1+size(Cg,2)/4+k*size(Cwg,2)/4:size(Cg,2)/4+...
               (k+1)*size(Cwg,2)/4)=Cg(1+size(Cg,2)/4+...
               k*size(Cwg,2)/4:size(Cg,2)/4+(k+1)*size(Cwg,2)/4)+...
               g*Cwg(1+size(Cwg,2)/4:size(Cwg,2)/2);
       Cg(1+size(Cg,2)/2+k*size(Cwg,2)/4:size(Cg,2)/2+...
               (k+1)*size(Cwg,2)/4)=Cg(1+size(Cg,2)/2+...
               k*size(Cwg,2)/4:size(Cg,2)/2+(k+1)*size(Cwg,2)/4)+...
               g*Cwg(1+size(Cwg,2)/2:3*size(Cwg,2)/4);
       Cg(1+3*size(Cg,2)/4+k*size(Cwg,2)/4:3*size(Cg,2)/4+...
               (k+1)*size(Cwg,2)/4)=Cg(1+3*size(Cg,2)/4+...
               k*size(Cwg,2)/4:3*size(Cg,2)/4+(k+1)*size(Cwg,2)/4)+...
               g*Cwg(1+3*size(Cwg,2)/4:size(Cwg,2));
       k=k+1;
end
Cg(1:size(Cwg,2)/4)=Cg(1:size(Cwg,2)/4)+g*Cwg(1:size(Cwg,2)/4);
b=0.16;
%水印B的分解
[Cwb,Swb]=wavedec2(waterb,1,'haar');
%图像B的分解
[Cb,Sb]=wavedec2(inputb,2,'haar');
%水印的嵌入
Cb(1:size(Cwb,2)/16)+b*Cwb(1:size(Cwb,2)/16);
k=0;
while k<=size(Cb,2)/size(Cwb,2)-1
       Cb(1+size(Cb,2)/4+k*size(Cwb,2)/4:size(Cb,2)/4+...
               (k+1)*size(Cwb,2)/4)=Cb(1+size(Cb,2)/4+...
               k*size(Cwb,2)/4:size(Cb,2)/4+(k+1)*size(Cwb,2)/4)+...
               g*Cwb(1+size(Cwb,2)/4:size(Cwb,2)/2);
       Cb(1+size(Cb,2)/2+k*size(Cwb,2)/4:size(Cb,2)/2+...
               (k+1)*size(Cwb,2)/4)=Cb(1+size(Cb,2)/2+...
               k*size(Cwb,2)/4:size(Cb,2)/2+(k+1)*size(Cwb,2)/4)+...
               b*Cwb(1+size(Cwb,2)/2:3*size(Cwb,2)/4);
        Cb(1+3*size(Cb,2)/4+k*size(Cwb,2)/4:3*size(Cb,2)/4+...
               (k+1)*size(Cwb,2)/4)=Cb(1+3*size(Cb,2)/4+...
               k*size(Cwb,2)/4:3*size(Cb,2)/4+(k+1)*size(Cwb,2)/4)+...
               b*Cwb(1+3*size(Cwb,2)/4:size(Cwb,2));
       k=k+1;
end
Cb(1:size(Cwb,2)/4)=Cb(1:size(Cwb,2)/4)+b*Cwb(1:size(Cwb,2)/4);
%图像的重构
inputr=waverec2(Cr,Sr,'haar');
inputg=waverec2(Cg,Sg,'haar');
inputb=waverec2(Cb,Sb,'haar');
%三色的叠加
temp=size(inputr);
pic=zeros(temp(1),temp(2),3);
for i=1:temp(1)
     for j=1:temp(2)
           pic(i,j,1)=inputr(i,j);
           pic(i,j,2)=inputg(i,j);
           pic(i,j,3)=inputb(i,j);
     end
end

% convert back to uint8
watermarked_image_uint8=uint8(round(pic));
watermrkd_img=watermarked_image_uint8;


%提取水印
%读出原始图像
input=cover_object;
%读出水印图像
watermarked_image=watermrkd_img;

%原始图像和水印图像的三色分离
input=double(input);
watermarked_image=double(watermarked_image);
inputr=input(:,:,1);
watermarked_imager=watermarked_image(:,:,1);
inputg=input(:,:,2);
watermarked_imageg=watermarked_image(:,:,2);
inputb=input(:,:,3);
watermarked_imageb=watermarked_image(:,:,3);
%水印图像R的分解
[Cwr,Swr]=wavedec2(watermarked_imager,2,'haar');
%图像R的分解
[Cr,Sr]=wavedec2(inputr,2,'haar');
%水印图像G的分解
[Cwg,Swg]=wavedec2(watermarked_imageg,2,'haar');
%图像G的分解
[Cg,Sg]=wavedec2(inputg,2,'haar');
%水印图像B的分解
[Cwb,Swb]=wavedec2(watermarked_imageb,2,'haar');
%图像B的分解
[Cb,Sb]=wavedec2(inputb,2,'haar');
%提取水印的小波系数
r=0.04;
for k=0:3
whr(k+1,:)=Cwr(1+size(Cwr,2)/4+k*size(Cwr,2)/16:size(Cwr,2)/4+(k+1)*size(Cwr,2)/16)-...
Cr(1+size(Cr,2)/4+k*size(Cr,2)/16:size(Cr,2)/4+(k+1)*size(Cr,2)/16);

wvr(k+1,:)=Cwr(1+size(Cwr,2)/2+k*size(Cwr,2)/16:size(Cwr,2)/2+(k+1)*size(Cwr,2)/16)-...
Cr(1+size(Cr,2)/2+k*size(Cr,2)/16:size(Cr,2)/2+(k+1)*size(Cr,2)/16);

wdr(k+1,:)=Cwr(1+3*size(Cwr,2)/4+k*size(Cwr,2)/16:3*size(Cwr,2)/4+(k+1)*size(Cwr,2)/16)-...
Cr(1+3*size(Cr,2)/4+k*size(Cr,2)/16:3*size(Cr,2)/4+(k+1)*size(Cr,2)/16);
end

whr=(whr(1,:)+whr(2,:)+whr(3,:)+whr(4,:))/(4*r);
wvr=(wvr(1,:)+wvr(2,:)+wvr(3,:)+wvr(4,:))/(4*r);
wdr=(wdr(1,:)+wdr(2,:)+wdr(3,:)+wdr(4,:))/(4*r);
war=(Cwr(1:size(Cwr,2)/16)-Cr(1:size(Cr,2)/16))/r;

g=0.02;
for k=0:3
whg(k+1,:)=Cwg(1+size(Cwg,2)/4+k*size(Cwg,2)/16:size(Cwg,2)/4+(k+1)*size(Cwg,2)/16)-...
Cg(1+size(Cg,2)/4+k*size(Cg,2)/16:size(Cg,2)/4+(k+1)*size(Cg,2)/16);

wvg(k+1,:)=Cwg(1+size(Cwg,2)/2+k*size(Cwg,2)/16:size(Cwg,2)/2+(k+1)*size(Cwg,2)/16)-...
Cg(1+size(Cg,2)/2+k*size(Cg,2)/16:size(Cg,2)/2+(k+1)*size(Cg,2)/16);

wdg(k+1,:)=Cwg(1+3*size(Cwg,2)/4+k*size(Cwg,2)/16:3*size(Cwg,2)/4+(k+1)*size(Cwg,2)/16)-...
Cg(1+3*size(Cg,2)/4+k*size(Cg,2)/16:3*size(Cg,2)/4+(k+1)*size(Cg,2)/16);
end

whg=(whg(1,:)+whg(2,:)+whg(3,:)+whg(4,:))/(4*g);
wvg=(wvg(1,:)+wvg(2,:)+wvg(3,:)+wvg(4,:))/(4*g);
wdg=(wdg(1,:)+wdg(2,:)+wdg(3,:)+wdg(4,:))/(4*g);
wag=(Cwg(1:size(Cwg,2)/16)-Cg(1:size(Cg,2)/16))/g;

b=0.08;
for k=0:3
whb(k+1,:)=Cwb(1+size(Cwb,2)/4+k*size(Cwb,2)/16:size(Cwb,2)/4+(k+1)*size(Cwb,2)/16)-...
Cb(1+size(Cb,2)/4+k*size(Cb,2)/16:size(Cb,2)/4+(k+1)*size(Cb,2)/16);

wvb(k+1,:)=Cwb(1+size(Cwb,2)/2+k*size(Cwb,2)/16:size(Cwb,2)/2+(k+1)*size(Cwb,2)/16)-...
Cb(1+size(Cb,2)/2+k*size(Cb,2)/16:size(Cb,2)/2+(k+1)*size(Cb,2)/16);

wdb(k+1,:)=Cwb(1+3*size(Cwb,2)/4+k*size(Cwb,2)/16:3*size(Cwb,2)/4+(k+1)*size(Cwb,2)/16)-...
Cb(1+3*size(Cb,2)/4+k*size(Cb,2)/16:3*size(Cb,2)/4+(k+1)*size(Cb,2)/16);
end

whb=(whb(1,:)+whb(2,:)+whb(3,:)+whb(4,:))/(4*b);
wvb=(wvb(1,:)+wvb(2,:)+wvb(3,:)+wvb(4,:))/(4*b);
wdb=(wdb(1,:)+wdb(2,:)+wdb(3,:)+wdb(4,:))/(4*b);
wab=(Cwb(1:size(Cwb,2)/16)-Cb(1:size(Cb,2)/16))/b;

%重构水印图像
cwr=[war,whr,wvr,wdr];
swr(:,1)=[sqrt(size(war,2)),sqrt(size(war,2)),2*sqrt(size(war,2))];
swr(:,2)=[sqrt(size(war,2)),sqrt(size(war,2)),2*sqrt(size(war,2))];
wr=waverec2(cwr,swr,'haar');

cwg=[wag,whg,wvg,wdg];
swg(:,1)=[sqrt(size(wag,2)),sqrt(size(wag,2)),2*sqrt(size(wag,2))];
swg(:,2)=[sqrt(size(wag,2)),sqrt(size(wag,2)),2*sqrt(size(wag,2))];
wg=waverec2(cwg,swg,'haar');

cwb=[wab,whb,wvb,wdb];
swb(:,1)=[sqrt(size(wab,2)),sqrt(size(wab,2)),2*sqrt(size(wab,2))];
swb(:,2)=[sqrt(size(wab,2)),sqrt(size(wab,2)),2*sqrt(size(wab,2))];
wb=waverec2(cwb,swb,'haar');

%三色叠加
temp=size(wr);
pic=zeros(temp(1),temp(2),3);
for i=1:temp(1)
     for j=1:temp(2)
          pic(i,j,1)=wr(i,j);
          pic(i,j,2)=wg(i,j);
          pic(i,j,3)=wb(i,j);
     end
end

output=uint8(round(pic));
%转换为uint8
recmessage_uint8=uint8(output);

% read in original watermark
orig_watermark=double(message);
 
% determine size of original watermark
Mo=size(orig_watermark,1);  %Height
No=size(orig_watermark,2);  %Width
Lo=size(orig_watermark,3);  %Width

 recmessage=reshape(recmessage_uint8,Mo,No,Lo);
 
 
%攻击
attack_image=attack(watermrkd_img,var);

%提取攻击后的水印
%读出原始图像
input=cover_object;
%读出水印图像
watermarked_image=attack_image;

%原始图像和水印图像的三色分离
input=double(input);
watermarked_image=double(watermarked_image);
inputr=input(:,:,1);
watermarked_imager=watermarked_image(:,:,1);
inputg=input(:,:,2);
watermarked_imageg=watermarked_image(:,:,2);
inputb=input(:,:,3);
watermarked_imageb=watermarked_image(:,:,3);
%水印图像R的分解
[Cwr,Swr]=wavedec2(watermarked_imager,2,'haar');
%图像R的分解
[Cr,Sr]=wavedec2(inputr,2,'haar');
%水印图像G的分解
[Cwg,Swg]=wavedec2(watermarked_imageg,2,'haar');
%图像G的分解
[Cg,Sg]=wavedec2(inputg,2,'haar');
%水印图像B的分解
[Cwb,Swb]=wavedec2(watermarked_imageb,2,'haar');
%图像B的分解
[Cb,Sb]=wavedec2(inputb,2,'haar');
%提取水印的小波系数
r=0.04;
for k=0:3
whr(k+1,:)=Cwr(1+size(Cwr,2)/4+k*size(Cwr,2)/16:size(Cwr,2)/4+(k+1)*size(Cwr,2)/16)-...
Cr(1+size(Cr,2)/4+k*size(Cr,2)/16:size(Cr,2)/4+(k+1)*size(Cr,2)/16);

wvr(k+1,:)=Cwr(1+size(Cwr,2)/2+k*size(Cwr,2)/16:size(Cwr,2)/2+(k+1)*size(Cwr,2)/16)-...
Cr(1+size(Cr,2)/2+k*size(Cr,2)/16:size(Cr,2)/2+(k+1)*size(Cr,2)/16);

wdr(k+1,:)=Cwr(1+3*size(Cwr,2)/4+k*size(Cwr,2)/16:3*size(Cwr,2)/4+(k+1)*size(Cwr,2)/16)-...
Cr(1+3*size(Cr,2)/4+k*size(Cr,2)/16:3*size(Cr,2)/4+(k+1)*size(Cr,2)/16);
end

whr=(whr(1,:)+whr(2,:)+whr(3,:)+whr(4,:))/(4*r);
wvr=(wvr(1,:)+wvr(2,:)+wvr(3,:)+wvr(4,:))/(4*r);
wdr=(wdr(1,:)+wdr(2,:)+wdr(3,:)+wdr(4,:))/(4*r);
war=(Cwr(1:size(Cwr,2)/16)-Cr(1:size(Cr,2)/16))/r;

g=0.02;
for k=0:3
whg(k+1,:)=Cwg(1+size(Cwg,2)/4+k*size(Cwg,2)/16:size(Cwg,2)/4+(k+1)*size(Cwg,2)/16)-...
Cg(1+size(Cg,2)/4+k*size(Cg,2)/16:size(Cg,2)/4+(k+1)*size(Cg,2)/16);

wvg(k+1,:)=Cwg(1+size(Cwg,2)/2+k*size(Cwg,2)/16:size(Cwg,2)/2+(k+1)*size(Cwg,2)/16)-...
Cg(1+size(Cg,2)/2+k*size(Cg,2)/16:size(Cg,2)/2+(k+1)*size(Cg,2)/16);

wdg(k+1,:)=Cwg(1+3*size(Cwg,2)/4+k*size(Cwg,2)/16:3*size(Cwg,2)/4+(k+1)*size(Cwg,2)/16)-...
Cg(1+3*size(Cg,2)/4+k*size(Cg,2)/16:3*size(Cg,2)/4+(k+1)*size(Cg,2)/16);
end

whg=(whg(1,:)+whg(2,:)+whg(3,:)+whg(4,:))/(4*g);
wvg=(wvg(1,:)+wvg(2,:)+wvg(3,:)+wvg(4,:))/(4*g);
wdg=(wdg(1,:)+wdg(2,:)+wdg(3,:)+wdg(4,:))/(4*g);
wag=(Cwg(1:size(Cwg,2)/16)-Cg(1:size(Cg,2)/16))/g;

b=0.08;
for k=0:3
whb(k+1,:)=Cwb(1+size(Cwb,2)/4+k*size(Cwb,2)/16:size(Cwb,2)/4+(k+1)*size(Cwb,2)/16)-...
Cb(1+size(Cb,2)/4+k*size(Cb,2)/16:size(Cb,2)/4+(k+1)*size(Cb,2)/16);

wvb(k+1,:)=Cwb(1+size(Cwb,2)/2+k*size(Cwb,2)/16:size(Cwb,2)/2+(k+1)*size(Cwb,2)/16)-...
Cb(1+size(Cb,2)/2+k*size(Cb,2)/16:size(Cb,2)/2+(k+1)*size(Cb,2)/16);

wdb(k+1,:)=Cwb(1+3*size(Cwb,2)/4+k*size(Cwb,2)/16:3*size(Cwb,2)/4+(k+1)*size(Cwb,2)/16)-...
Cb(1+3*size(Cb,2)/4+k*size(Cb,2)/16:3*size(Cb,2)/4+(k+1)*size(Cb,2)/16);
end

whb=(whb(1,:)+whb(2,:)+whb(3,:)+whb(4,:))/(4*b);
wvb=(wvb(1,:)+wvb(2,:)+wvb(3,:)+wvb(4,:))/(4*b);
wdb=(wdb(1,:)+wdb(2,:)+wdb(3,:)+wdb(4,:))/(4*b);
wab=(Cwb(1:size(Cwb,2)/16)-Cb(1:size(Cb,2)/16))/b;

%重构水印图像
cwr=[war,whr,wvr,wdr];
swr(:,1)=[sqrt(size(war,2)),sqrt(size(war,2)),2*sqrt(size(war,2))];
swr(:,2)=[sqrt(size(war,2)),sqrt(size(war,2)),2*sqrt(size(war,2))];
wr=waverec2(cwr,swr,'haar');

cwg=[wag,whg,wvg,wdg];
swg(:,1)=[sqrt(size(wag,2)),sqrt(size(wag,2)),2*sqrt(size(wag,2))];
swg(:,2)=[sqrt(size(wag,2)),sqrt(size(wag,2)),2*sqrt(size(wag,2))];
wg=waverec2(cwg,swg,'haar');

cwb=[wab,whb,wvb,wdb];
swb(:,1)=[sqrt(size(wab,2)),sqrt(size(wab,2)),2*sqrt(size(wab,2))];
swb(:,2)=[sqrt(size(wab,2)),sqrt(size(wab,2)),2*sqrt(size(wab,2))];
wb=waverec2(cwb,swb,'haar');

%三色叠加
temp=size(wr);
pic=zeros(temp(1),temp(2),3);
for i=1:temp(1)
     for j=1:temp(2)
          pic(i,j,1)=wr(i,j);
          pic(i,j,2)=wg(i,j);
          pic(i,j,3)=wb(i,j);
     end
end

output=uint8(round(pic));
%转换为uint8
attack_message_uint8=uint8(output);

attack_message=reshape(attack_message_uint8,Mo,No,Lo);

% calculate the PSNR
I0     = double(cover_object);
I1     = double(watermarked_image_uint8);
Id     = (I0-I1);
signal = sum(sum(I0.^2));
noise  = sum(sum(Id.^2));
MSE  = noise./numel(I0);
peak = max(I0(:));
PSNR = 10*log10(peak^2/MSE(:,:,1));
% PSNR_a
A0=double(watermarked_image_uint8);
A1=double(attack_image);
Ad=(A0-A1);
signal_a = sum(sum(A0.^2));
noise_a  = sum(sum(Ad.^2));
MSE_a  = noise_a./numel(A0);
peak_a = max(A0(:));
PSNR_a = 10*log10(peak_a^2/MSE_a(:,:,1));


%Normalized Cross Correlation
NCC=nc(double(message1),double(recmessage));
% NCC_a
NCC_a=nc(double(message1),double(attack_message));

% calculate the SSIM
MSSIM=ssim(cover_object,watermrkd_img);
% MSSIM_a
MSSIM_a=ssim(watermrkd_img,attack_image);



end



