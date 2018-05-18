#include <stdlib.h>
#include <stdio.h>

int main(){
    FILE *in_file = fopen("PNG_HEX_SPRITES/Megaman_facing_right.txt", "r");
    FILE *out_file = fopen("PNG_HEX_SPRITES/2D_Megaman_facing_right.txt", "w");


    int i,j;
    //change the height and width as needed
    if(in_file == NULL || out_file == NULL){
        printf("ERROR!");
        return 0;
    }
    for(i = 0; i < 60; i++){
        for(j =0; j< 60; j++){
            char character = fgetc(in_file);
            if(character != '\n'){
                fprintf(out_file, "%c", character);
                //if(j != 59 && j != 0)
                    //fprintf(out_file, ",");
            }
        }
        fprintf(out_file, "\n");
    }

    fclose(in_file);
    fclose(out_file);
    return 0;
}
