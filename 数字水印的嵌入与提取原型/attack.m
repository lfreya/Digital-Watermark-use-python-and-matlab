function [attack_image]=attack(watermrkd_img,var)

switch var
    case 1
        result_1=watermrkd_img;
        noise=10*randn(size(result_1));    %�������������
        result_1=double(result_1)+noise;        %��Ӱ�����
        attack_image=uint8(result_1);
    case 2
        result_2=imrotate(watermrkd_img,10,'bilinear','crop');   %���ڽ����Բ�ֵ�㷨��ת10��
        attack_image=result_2;
    case 3
        result_3=imrotate(watermrkd_img,30,'bilinear','crop');   %���ڽ����Բ�ֵ�㷨��ת30��
        attack_image=result_3;
    case 4
        attack_image=imnoise(watermrkd_img,'salt & pepper');
    case 5
        [cA1,cH1,cV1,cD1]=dwt2(watermrkd_img,'Haar');    %ͨ��С���任��ͼ�����ѹ��
        cA1=HYASUO(cA1);
        cH1=HYASUO(cH1);
        cV1=HYASUO(cV1);
        cD1=HYASUO(cD1);
        result_4=idwt2(cA1,cH1,cV1,cD1,'Haar');
        result_4=uint8(result_4);
        attack_image=result_4;
end
