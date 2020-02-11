function tfHt=readToolframeFile(tfFile)
    tfFileContent=xml2struct(tfFile);
    x=str2num(tfFileContent.HumerusToolframe.x.Text);
    y=str2num(tfFileContent.HumerusToolframe.y.Text);
    z=str2num(tfFileContent.HumerusToolframe.z.Text);
    w=str2num(tfFileContent.HumerusToolframe.w.Text);
    p=str2num(tfFileContent.HumerusToolframe.p.Text);
    r=str2num(tfFileContent.HumerusToolframe.r.Text);
    tfHt=ht(eul2rotm(fliplr(deg2rad([w p r]))), [x/1000 y/1000 z/1000]);
end