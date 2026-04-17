uniform vec4 outline;

vec4 effect(vec4 color, Image texture, vec2 imageCords, vec2 screenCords){
    if (color.a != 0){
        return outline;
    }
    else{
        return color;
    }
}