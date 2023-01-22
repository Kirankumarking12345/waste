# waste

/* add scale for the axes*/
    char scale[5];
    HPDF_Page_BeginText(page);
    for(int i=0; i<270; i=i+30)
    {
        sprintf(scale,"%d",i);
        HPDF_Page_TextOut(page, mov_rig+i, mov_up - 6, scale);
        HPDF_Page_TextOut(page, mov_rig-13, mov_up + i, scale);
    }
    

    HPDF_Page_TextOut(page, 250,  450, "flux");
    HPDF_Page_TextOut(page, 250,  430, "bp");
    HPDF_Page_EndText(page);

    HPDF_Page_SetRGBStroke(page, 1, 0, 0);
    HPDF_Page_MoveTo(page, 220, 453);
    HPDF_Page_LineTo(page, 240, 453);
    HPDF_Page_Stroke(page);

    HPDF_Page_SetRGBStroke(page, 0, 0, 1);
    HPDF_Page_MoveTo(page, 220, 433);
    HPDF_Page_LineTo(page, 240, 433);
    HPDF_Page_Stroke(page);
