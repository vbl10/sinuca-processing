class Mesa
{
  public Coord tamanho;
  public Coord cacapas[];
  public float cacapaRaio;
  public float atritoAcel;
  
  Mesa(Coord tamanho, float cacapaRaio, float atritoAcel)
  {
    this.atritoAcel = atritoAcel;
    this.tamanho = tamanho;
    this.cacapaRaio = cacapaRaio;
    
    cacapas = new Coord[6];
    for (int i = 0; i < 6; i++)
      cacapas[i] = new Coord();
    posicionarCacapas();
  }
  private void posicionarCacapas()
  {
    for (int i = 0; i < 2; i++)
    {
      for (int j = 0; j < 3; j++)
      {
        cacapas[i * 3 + j].x = (j - 1) * tamanho.x / 2;
        cacapas[i * 3 + j].y = (i * 2 - 1) * tamanho.y / 2;
      }
    }
    cacapas[0] = cacapas[0].soma(new Coord(+2.0f, +2.0f));
    cacapas[2] = cacapas[2].soma(new Coord(-2.0f, +2.0f));
    cacapas[3] = cacapas[3].soma(new Coord(+2.0f, -2.0f));
    cacapas[5] = cacapas[5].soma(new Coord(-2.0f, -2.0f));
  }
  
  public Coord cantoSupEsq()
  {
    return new Coord(-tamanho.x/2, -tamanho.y/2);
  }
  public Coord cantoSupDir()
  {
    return new Coord(tamanho.x/2, -tamanho.y/2);
  }
  public Coord cantoInfEsq()
  {
    return new Coord(-tamanho.x/2, tamanho.y/2);
  }
  public Coord cantoInfDir()
  {
    return new Coord(tamanho.x/2, tamanho.y/2);
  }
  
  public boolean colideComEsq(Bola bola)
  {
    return bola.pos.x - Bola.raio < -tamanho.x / 2;
  }
  public boolean colideComDir(Bola bola)
  {
    return bola.pos.x + Bola.raio > tamanho.x / 2;
  }
  public boolean colideComSup(Bola bola)
  {
    return bola.pos.y - Bola.raio < -tamanho.y / 2;
  }
  public boolean colideComInf(Bola bola)
  {
    return bola.pos.y + Bola.raio > tamanho.y / 2;
  }
  public boolean colideCom(Bola bola)
  {
    return colideComEsq(bola) || colideComDir(bola) || colideComSup(bola) || colideComInf(bola);
  }
  
  public void desenhar()
  {
    fill(30, 57, 12);
    strokeWeight(20);
    stroke(54, 32, 12);
    rect(-tamanho.x / 2, -tamanho.y / 2, tamanho.x, tamanho.y, 1.0f);
    noStroke();
    rect(-tamanho.x / 2, -tamanho.y / 2, tamanho.x, tamanho.y, 1.0f);
    
    //caçapas
    strokeWeight(0);
    fill(0);
    for (int i = 0; i < 6; i++)
    {
      circle(cacapas[i].x, cacapas[i].y, cacapaRaio * 2);
    }
  }
};
