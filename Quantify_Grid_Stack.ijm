values = newArray(0,32,64,96,128,160,192,224,256,288,320,352,384,416,448,480);

for(i=0;i<16;i++){
 for(yy=0;yy<16;yy++){
    makeRectangle(values[i],values[yy], 32, 32);
    run("Measure Stack...");
    }
 }


