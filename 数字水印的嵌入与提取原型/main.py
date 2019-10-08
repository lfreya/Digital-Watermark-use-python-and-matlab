#coding=utf-8
import sys
import os
from PyQt5 import QtWidgets,QtCore,QtGui
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from matlab import engine

from mainUI import *
import mainUI
import Evaluation

import matlab
import matlab.engine

import numpy as np

import qimage2ndarray
from QImageToNumpy import QImageToCvMat


# 点击各方法按钮弹出的评价值表格
class ChildWindow(QDialog,Evaluation.Ui_Dialog,QTableWidget):
    def __init__(self):
        QDialog.__init__(self)
        self.dialog=Evaluation.Ui_Dialog()
        self.dialog.setupUi(self)



class MainCode(QMainWindow,mainUI.Ui_MainWindow):
    def __init__(self):
        QMainWindow.__init__(self)
        mainUI.Ui_MainWindow.__init__(self)
        self.setupUi(self)
        self.img_open.clicked.connect(self.on_open1)
        self.message_open.clicked.connect(self.on_open2)
        self.DWT.clicked.connect(self.dwt_exc)
        self.DCT.clicked.connect(self.dct_exc)



# 选择载体图像
    def on_open1(self):
        imgName1, imgType = QFileDialog.getOpenFileName(self, "Pick an Image File", "./picture/", "*.jpg;;*.png;;*.ppm;;All Files(*)")
        jpg1 = QtGui.QPixmap(imgName1)
        self.img1.setScaledContents(True)
        self.img1.setPixmap(jpg1)
        name=imgName1[45:]
        self.cover_img.setPlainText(name)


# 选择水印图像
    def on_open2(self):
        imgName2,imgType = QFileDialog.getOpenFileName(self, 'Pick an Image File', "./picture/", "*.bmp;;*.jpg;;*.png;;All Files(*)")
        jpg2 = QtGui.QPixmap(imgName2)
        self.img2.setScaledContents(True)
        self.img2.setPixmap(jpg2)
        name = imgName2[45:]
        self.message_img.setPlainText(name)



# 基于DWT的水印嵌入与提取
    def dwt_exc(self):
        # get picture from QLabel
        image1 = self.img1.pixmap().toImage()
        image2 = self.img2.pixmap().toImage()
        # QImage to array,otherwise cannot use matlab
        cover = QImageToCvMat(image1)
        message1 = QImageToCvMat(image2)
        height = message1.shape[0]
        width = message1.shape[1]
        cover_object = matlab.uint8(cover.tolist())
        message = matlab.uint8(message1.tolist())
        # var is number of attact function
        var = self.comboBox.currentIndex() + 1
        # 调用matlab
        engine = matlab.engine.start_matlab()
        watermrkd_img, recmessage,attack_image, attack_message, PSNR, NCC, MSSIM,PSNR_a, NCC_a, MSSIM_a=engine.dwt(cover_object, message, height,width,var, nargout=10)
        watermrkd_img = np.array(watermrkd_img)
        recmessage = np.array(recmessage)
        attack_image = np.array(attack_image)
        attack_message = np.array(attack_message)
        # transform picture from matlab (array to qimage), and show on the GUI
        jpg3 = qimage2ndarray.array2qimage(watermrkd_img)
        watermrkd = QtGui.QPixmap(jpg3)
        self.img3.setScaledContents(True)
        self.img3.setPixmap(watermrkd)
        jpg4 = qimage2ndarray.array2qimage(recmessage)
        rec = QtGui.QPixmap(jpg4)
        self.img4.setScaledContents(True)
        self.img4.setPixmap(rec)
        jpg5 = qimage2ndarray.array2qimage(attack_image)
        atk = QtGui.QPixmap(jpg5)
        self.img5.setScaledContents(True)
        self.img5.setPixmap(atk)
        jpg6 = qimage2ndarray.array2qimage(attack_message)
        atk_msg = QtGui.QPixmap(jpg6)
        self.img6.setScaledContents(True)
        self.img6.setPixmap(atk_msg)
        # 弹出评价值表格
        self.child = ChildWindow()
        self.child.dialog.tableWidget.setItem(0, 0, QTableWidgetItem("%.8f" % PSNR))
        self.child.dialog.tableWidget.setItem(0, 1, QTableWidgetItem("%.8f" % NCC))
        self.child.dialog.tableWidget.setItem(0, 2, QTableWidgetItem("%.8f" % MSSIM))
        self.child.dialog.tableWidget.setItem(1, 0, QTableWidgetItem("%.8f" % PSNR_a))
        self.child.dialog.tableWidget.setItem(1, 1, QTableWidgetItem("%.8f" % NCC_a))
        self.child.dialog.tableWidget.setItem(1, 2, QTableWidgetItem("%.8f" % MSSIM_a))
        layout = QHBoxLayout()
        layout.addWidget(self.child.dialog.tableWidget)
        self.child.setLayout(layout)
        self.child.show()



# 基于DCT的水印嵌入与提取
    def dct_exc(self):
        image1 = self.img1.pixmap().toImage()
        image2 = self.img2.pixmap().toImage()
        # 获取QLabel上的图片并转成numpy格式，再转成list，传入matlab
        cover=QImageToCvMat(image1)
        message1=QImageToCvMat(image2)
        height=message1.shape[0]
        width=message1.shape[1]
        cover_object = matlab.uint8(cover.tolist())
        message = matlab.uint8(message1.tolist())
        var=self.comboBox.currentIndex()+1
        # 调用matlab
        engine = matlab.engine.start_matlab()
        watermrkd_img, recmessage, attack_image, attack_message, PSNR, NCC, MSSIM, PSNR_a, NCC_a, MSSIM_a= engine.dct(cover_object, message, height, width, var, nargout=10)
        watermrkd_img=np.array(watermrkd_img)
        recmessage = np.array(recmessage)
        attack_image = np.array(attack_image)
        attack_message = np.array(attack_message)
        # transform picture from matlab (array to qimage), and show on the GUI
        jpg3=qimage2ndarray.array2qimage(watermrkd_img)
        watermrkd = QtGui.QPixmap(jpg3)
        self.img3.setScaledContents(True)
        self.img3.setPixmap(watermrkd)
        jpg4 = qimage2ndarray.array2qimage(recmessage)
        rec = QtGui.QPixmap(jpg4)
        self.img4.setScaledContents(True)
        self.img4.setPixmap(rec)
        jpg5 = qimage2ndarray.array2qimage(attack_image)
        atk = QtGui.QPixmap(jpg5)
        self.img5.setScaledContents(True)
        self.img5.setPixmap(atk)
        jpg6 = qimage2ndarray.array2qimage(attack_message)
        atk_msg = QtGui.QPixmap(jpg6)
        self.img6.setScaledContents(True)
        self.img6.setPixmap(atk_msg)
        # 弹出评价值表格
        self.child=ChildWindow()
        self.child.dialog.tableWidget.setItem(0, 0, QTableWidgetItem("%.8f" % PSNR))
        self.child.dialog.tableWidget.setItem(0, 1, QTableWidgetItem("%.8f" % NCC))
        self.child.dialog.tableWidget.setItem(0, 2, QTableWidgetItem("%.8f" % MSSIM))
        self.child.dialog.tableWidget.setItem(1, 0, QTableWidgetItem("%.8f" % PSNR_a))
        self.child.dialog.tableWidget.setItem(1, 1, QTableWidgetItem("%.8f" % NCC_a))
        self.child.dialog.tableWidget.setItem(1, 2, QTableWidgetItem("%.8f" % MSSIM_a))
        layout=QHBoxLayout()
        layout.addWidget(self.child.dialog.tableWidget)
        self.child.setLayout(layout)
        self.child.show()



if __name__=="__main__":

    QtCore.QCoreApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling)
    app=QtWidgets.QApplication(sys.argv)

    my=MainCode()
    my.show()
    sys.exit(app.exec())