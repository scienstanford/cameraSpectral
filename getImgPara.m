function [image]= getImgPara(filename)
[~,name,~] = fileparts(filename);
image.camera = strtok(name,'_');
name = erase(name,image.camera);
image.width = strtok(name,'_');
name = erase(name,image.width);
image.height = strtok(name,'_');
name = erase(name,image.height);
image.bit = strtok(name,'_');
name = erase(name,image.bit);
image.pattern = strtok(name,'_');
name = erase(name,image.pattern);
part = strtok(name,'_');
name = erase(name,part);
image.Exptime = strtok(name,'_');
name = erase(name,image.Exptime);
part = strtok(name,'_');
name = erase(name,part);
image.AnalogGain= strtok(name,'_');
name = erase(name, image.AnalogGain);
end


