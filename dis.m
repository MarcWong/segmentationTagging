function dist = dis(r,g,b,label,tag)
    v(1) = double(r) - label(tag,1);
    v(2) = double(g) - label(tag,2);
    v(3) = double(b) - label(tag,3);
    dist = norm(v,2);
end