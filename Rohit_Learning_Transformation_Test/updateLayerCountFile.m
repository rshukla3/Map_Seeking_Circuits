function [  ] = updateLayerCountFile( layerCount )
%updateLayerCountFile: Update the number of layers for MSC in layers.txt
%file.
layersSaved = layerCount-1;
dlmwrite('layer.txt', layersSaved, '\t');
end

