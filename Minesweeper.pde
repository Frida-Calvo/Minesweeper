

import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    
    for(int r = 0; r<NUM_ROWS; r++)
        for(int c=0; c<NUM_COLS; c++)
            buttons[r][c]= new MSButton(r,c);
    
    setBombs();
}
public void setBombs()
{
    while(bombs.size() < 1){
        int r = (int)(Math.random() * NUM_ROWS);
        int c = (int)(Math.random() * NUM_COLS);
        if(!bombs.contains(buttons[r][c])){
            bombs.add(buttons[r][c]);
            System.out.println(r + ", " + c);
        }
    }
}
    

public void draw ()
{
    background( 0 );
}

public boolean isWon()
{
    int filled = 0;
    for(int num =0; num < bombs.size(); num++)
        if(bombs.get(num).isMarked()==true)
            filled++;
    if(filled == bombs.size())
        return true;
    else
        return false;
}
public void displayLosingMessage()
{
    System.out.println("you lost");


    fill(93, 153, 133); //green
    rect(100, 180, 200, 50);
    // rect(x, y, width, height);
    textSize(40);
    fill(130, 180, 216);//light blue
    text("You lose", 200, 200);

}
public void displayWinningMessage()
{
    fill(195, 165, 206); //purple
    rect(100, 180, 200, 50);
    // rect(x, y, width, height);
    textSize(40);
    fill(255, 201, 245);//pink
    text("You win!", 200, 200);
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT){
            marked =! marked;   //able to mark and unmark the box
            if(marked == false)
                clicked = false;
        }
        else if(bombs.contains(this))
            displayLosingMessage();



        else if(countBombs(r,c) > 0)
            setLabel("" + countBombs(r,c));
        else{

            if(isValid(r, c-1) == true && buttons[r][c-1].clicked == false)//left
                buttons[r][c-1].mousePressed();
            if(isValid(r, c+1) == true && buttons[r][c+1].clicked == false)//right
                buttons[r][c+1].mousePressed();
            
            if(isValid(r+1, c) == true && buttons[r+1][c].clicked == false)//down
                buttons[r+1][c].mousePressed();
            if(isValid(r+1, c-1) == true && buttons[r+1][c-1].clicked == false)//down left
                buttons[r+1][c-1].mousePressed();
            if(isValid(r+1, c+1) == true && buttons[r+1][c+1].clicked == false)//down right
                buttons[r+1][c+1].mousePressed();

            if(isValid(r-1, c) == true && buttons[r-1][c].clicked == false)//up
                buttons[r-1][c].mousePressed();
            if(isValid(r-1, c+1) == true && buttons[r-1][c+1].clicked == false)//right up
                buttons[r-1][c+1].mousePressed();
            if(isValid(r-1, c-1) == true && buttons[r-1][c-1].clicked == false)//left up
                buttons[r-1][c-1].mousePressed();
        }


    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 ); 

        rect(x, y, width, height);
        fill(255,255,255);
        textSize(15);
        text(label,x+width/2,y+height/2);

        if(isWon()){
        displayWinningMessage();
    }

    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r < NUM_ROWS && r>= 0 && c < NUM_COLS && c >= 0)
            return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int r = row-1; r<= row+1;r++)
            for(int c = col-1; c <= col+1; c++)
                if(isValid(r,c)==true && bombs.contains(buttons[r][c]))
                    numBombs++;
        if(bombs.contains(buttons[row][col])== true)
            numBombs--;
        return numBombs;
    }
}



