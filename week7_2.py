import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt
import math

def HighFreqEnhance(img,b,a,D0,n):
    M = np.size(img,0)
    N = np.size(img,1)
    butthpf = np.zeros([M,N])
    for u in range(M):
        for v in range(N):
            dist = math.sqrt((u-M/2)**2+(v-N/2)**2)
            if dist == 0:
                butthpf[u,v] = 0
            else:
                butthpf[u,v] = 1/(1+(D0/dist)**(2*n))
    hfe = a+b*butthpf
    f1 = np.fft.fft2(img)
    f1shift = np.fft.fftshift(f1)
    f_out = f1shift*hfe
    f2_shift = np.fft.ifftshift(f_out)
    img_out = np.fft.ifft2(f2_shift)
    img_out = abs(img_out)
    #gama = 0.3
    #img_out = img_out**(gama)
    img_out = img_out/np.max(np.max(img_out))
    return img_out
def HighFreqImprovment(img,A,D0,n):
    M = np.size(img,0)
    N = np.size(img,1)
    buttlpf = np.zeros([M,N])
    for u in range(M):
        for v in range(N):
            dist = math.sqrt((u-M/2)**2+(v-N/2)**2)
            buttlpf[u,v] = 1/(1+(dist/D0)**(2*n))
    f1 = np.fft.fft2(img)
    f1shift = np.fft.fftshift(f1)
    hfi = A*f1shift-buttlpf*f1shift
    f2_shift = np.fft.ifftshift(hfi)
    img_out = np.fft.ifft2(f2_shift)
    img_out = abs(img_out)
    #gama = 0.3
    #img_out = img_out**(gama)
    img_out = img_out/np.max(np.max(img_out))
    return img_out
def HistEqual(img):
    M = np.size(img,0)
    N = np.size(img,1)
    hist = np.zeros(256)
    cdf = np.zeros(256)
    img_flag = np.zeros([M,N])
    img_out = np.zeros([M,N])
    for u in range(M):
        for v in range(N):
            index = round(255*img[u,v])
            hist[index] += 1
            img_flag[u,v] = index
    cdf[0] = hist[0]
    for k in range(255):
        cdf[k+1] = cdf[k] + hist[k+1]
    cdf /= (M*N)
    for u in range(M):
        for v in range(N):
            index = round(255*img[u,v])
            level = int(cdf[index]*255+0.5)
            img_out[u,v] = level/255
    return img_out
def GrayExpansion(img,a,b):
    M = np.size(img,0)
    N = np.size(img,1)
    img_out = np.zeros([M,N])
    for u in range(M):
        for v in range(N):
            if img[u,v] < a:
                img_out[u,v] = 0
            elif img[u,v] > b:
                img_out[u,v] = 1 
            else:
                img_out[u,v] = 1/(b-a)*(img[u,v]-a)
    return img_out
if __name__ == '__main__':
    board = cv.imread('board-orig.bmp',0)
    plt.figure()
    plt.imshow(board,cmap = 'gray')
    plt.title("Board Original")

    board = board.astype(np.float32)/255
    M = np.size(board,0)
    N = np.size(board,1)

    hfe_board = HighFreqEnhance(board,1.75,0.5,M/8,1)
    hfe_linear = GrayExpansion(hfe_board,0.1,0.4)
    hfe_hist = HistEqual(hfe_board)
    
    plt.figure()
    plt.subplot(2,2,1)
    plt.imshow(board,cmap = 'gray')
    plt.title("board original")
    plt.subplot(2,2,2)
    plt.imshow(hfe_board,cmap = 'gray')
    plt.title("high-emphasis filtering")
    plt.subplot(2,2,3)
    plt.imshow(hfe_linear,cmap = 'gray')
    plt.title("linear mapping")
    plt.subplot(2,2,4)
    plt.imshow(hfe_hist,cmap = 'gray')
    plt.title("histogram equalization")

    hfi_board = HighFreqImprovment(board,1.4,M/8,1)    
    hfi_linear = GrayExpansion(hfi_board,0.1,0.5)
    hfi_hist = HistEqual(hfi_board)
    plt.figure()
    plt.subplot(2,2,1)
    plt.imshow(board,cmap = 'gray')
    plt.title("board original")
    plt.subplot(2,2,2)
    plt.imshow(hfi_board,cmap = 'gray')
    plt.title("high-boost filtering")
    plt.subplot(2,2,3)
    plt.imshow(hfi_linear,cmap = 'gray')
    plt.title("linear mapping")
    plt.subplot(2,2,4)
    plt.title("histogram equalization")
    plt.imshow(hfi_hist,cmap = 'gray')
    plt.show()
