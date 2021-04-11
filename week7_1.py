import numpy as np
import cv2 as cv
import math
import matplotlib.pyplot as plt
def IdealLPF(D0,img):
    M = np.size(img,0)
    N = np.size(img,1)
    lpf = np.zeros([M,N])
    for u in range(M):
        for v in range(N):
            dist = math.sqrt((u-M/2)**2+(v-N/2)**2)
            if dist < D0:
                lpf[u,v] = 1
    f1 = np.fft.fft2(img)
    f1shift = np.fft.fftshift(f1)
    if D0 == 16:
        plt.figure()
        temp = np.log(0.1*abs(f1shift)+1)
        plt.imshow(temp/temp.max(),cmap = 'gray')
        plt.title("Fourier Transform of Lena")
    f_out = f1shift*lpf
    f2_shift = np.fft.ifftshift(f_out)
    img_out = np.fft.ifft2(f2_shift)
    img_out = abs(img_out)
    img_out = img_out/np.max(np.max(img_out))
    return img_out

def Buttworth(D0,n,img):
    M = np.size(img,0)
    N = np.size(img,1)
    buttlpf = np.zeros([M,N])
    for u in range(M):
        for v in range(N):
            dist = math.sqrt((u-M/2)**2+(v-N/2)**2)
            buttlpf[u,v] = 1/(1+(dist/D0)**(2*n))
    f1 = np.fft.fft2(img)
    f1shift = np.fft.fftshift(f1)
    f_out = f1shift*buttlpf
    f2_shift = np.fft.ifftshift(f_out)
    img_out = np.fft.ifft2(f2_shift)
    img_out = abs(img_out)
    img_out = img_out/np.max(np.max(img_out))
    return img_out,buttlpf[:,M//2]

if __name__ == '__main__':
    lena = cv.imread('Lena.bmp',0)
    plt.figure()
    plt.title("Lena Original")
    plt.imshow(lena,cmap = 'gray')
    lena = lena.astype(np.float32)/255
    M = np.size(lena,0)
    N = np.size(lena,1)
    radius = min(M,N)
    D0 = np.array([radius/16,radius/8,radius/4,radius/2])
    N0 = np.array([1,2,3,4])
    lena_iplf = np.zeros([M,N,4])
    lena_butt = np.zeros([M,N,4,2])
    butt_center = np.zeros([M,4,2])
    for k in range(4):
        lena_iplf[:,:,k] = IdealLPF(D0[k],lena)
    for k in range(4):
        lena_butt[:,:,k,0],butt_center[:,k,0] = Buttworth(D0[k],2,lena)
    for k in range(4):
        lena_butt[:,:,k,1],butt_center[:,k,1] = Buttworth(radius/8,N0[k],lena)
    plt.figure()
    plt.title("Buttworth Lowpass Filter")
    for k in range(4):
        plt.subplot(2,2,k+1)
        plt.plot(range(M),butt_center[:,k,0])
        title_str = "D0 = "+str(D0[k])
        plt.title(title_str)
    plt.figure()
    plt.title("Buttworth Lowpass Filter")
    for k in range(4):
        plt.subplot(2,2,k+1)
        plt.plot(range(M),butt_center[:,k,1])
        title_str = "N = "+str(N0[k])
        plt.title(title_str)
    plt.figure()
    plt.title("Ideal Lowpass Filter")
    for k in range(4):
        plt.subplot(2,2,k+1)
        plt.imshow(lena_iplf[:,:,k],cmap = 'gray')
        title_str = "D0 = " + str(D0[k])
        plt.title(title_str)
    plt.figure()
    plt.title("Buttworth Lowpass Filter")
    for k in range(4):
        plt.subplot(2,2,k+1)
        plt.imshow(lena_butt[:,:,k,0],cmap = 'gray')
        title_str = "D0 = " + str(D0[k])
        plt.title(title_str)
    plt.figure()
    plt.title("Buttworth Lowpass Filter")
    for k in range(4):
        plt.subplot(2,2,k+1)
        plt.imshow(lena_butt[:,:,k,1],cmap = 'gray')
        title_str = "N = " + str(N0[k])
        plt.title(title_str)
    plt.show()
