class Bola
{
  public static final float raio = 2.7f; //cm
  Coord pos, vel;
  boolean estaEmJogo;
    
  Bola()
  {
    this.estaEmJogo = true;
    this.pos = new Coord();
    this.vel = new Coord();
  }
  
  public void desenhar(int numero)
  {
    strokeWeight(0.5);
    fill(cores.bola[numero]);
    if (numero < 9) stroke(cores.bola[numero]);
    else stroke(255, 255, 255);
    circle(pos.x, pos.y, Bola.raio * 2);
  }
};
