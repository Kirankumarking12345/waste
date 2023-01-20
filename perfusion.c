int xi,y;
    printf("Enter the location you want :");
    scanf("%d %d",&xi,&y);
    float sum=0;
    sum = Z[xi-2][y-2] + Z[xi-2][y - 1] + Z[xi-2][y] + Z[xi-2][y + 1] + Z[xi-2][y + 2] +
                Z[xi-1][y-2] + Z[xi-1][y - 1] + Z[xi-1][y] + Z[xi-1][y + 1] + Z[xi-1][y + 2] +
                Z[xi][y-2] + Z[xi][y - 1] + Z[xi][y] + Z[xi][y + 1] + Z[xi][y + 2] +
                Z[xi+1][y-2] + Z[xi+1][y - 1] + Z[xi+1][y] + Z[xi+1][y + 1] + Z[xi+1][y + 2] +
                Z[xi+2][y-2] + Z[xi+2][y - 1] + Z[xi+2][y] + Z[xi+2][y + 1] + Z[xi+2][y + 2] ; 
    float perfusion = (sum/25)*100;
    printf("%d \n",(int)perfusion);
