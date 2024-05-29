class Matriz
{
  public float a[] = new float[9];
  
  float em(int i, int j)
  {
    return a[i * 3 + j];
  }
  float def(int i, int j, float val)
  {
    return a[i * 3 + j] = val;
  }
  
  void imprimir()
  {
    for (int i = 0; i < 3; i++)
    {
      for (int j = 0; j < 3; j++)
      {
        print(em(i, j));
        print('\t');
      }
      println();
    }
    println();
  }
  
  Matriz mult(float b)
  {
    Matriz prod = new Matriz();
    for (int i = 0; i < 9; i++)
      prod.a[i] = a[i] * b;
    return prod;
  }
  
  Coord mult(Coord c)
  {
    Coord prod = new Coord();
    prod.x = em(0,0)*c.x + em(0,1)*c.y + em(0,2);
    prod.y = em(1,0)*c.x + em(1,1)*c.y + em(1,2);
    return prod;
  }
  
  Matriz mult(Matriz b)
  {
    Matriz prod = new Matriz();
    for (int i = 0; i < 3; i++)
    {
      for (int j = 0; j < 3; j++)
      {
        float val = 0f;
        for (int k = 0; k < 3; k++)
        {
          val += this.em(i, k) * b.em(k, j);
        }
        prod.def(i, j, val);
      }
    }
    return prod;
  }
  
  float det()
  {
    return 
      em(0,0)*em(1,1)*em(2,2) +
      em(0,1)*em(1,2)*em(2,0) +
      em(0,2)*em(1,0)*em(2,1) -
      em(0,2)*em(1,1)*em(2,0) -
      em(0,1)*em(1,0)*em(2,2) -
      em(0,0)*em(1,2)*em(2,1);
  }
  
  Matriz cofatores()
  {
    Matriz cof = new Matriz();
    
    //cofatores
    for (int i = 0; i < 3; i++)
    {
      for (int j = 0; j < 3; j++)
      {
        float sub[][] = new float[2][2];
        for (int k = 0, l = 0; k < 3; k++)
        {
          if (k != i)
          {
            for (int m = 0, n = 0; m < 3; m++)
            {
              if (m != j)
              {
                sub[l][n] = em(k, m);
                n++;
              }
            }
            l++;
          }
        }
        cof.def(i, j, (sub[0][0]*sub[1][1] - sub[0][1]*sub[1][0]) * ((i + j) % 2 == 1 ? -1f : 1f));
      }
    }
    
    return cof;
  }
  
  Matriz transposta()
  {
    Matriz t = new Matriz();
    for (int i = 0; i < 3; i++)
    {
      for (int j = 0; j < 3; j++)
      {
        t.def(i, j, em(j, i));
      }
    }
    return t;
  }
  
  Matriz inversa()
  {
    return cofatores().transposta().mult(1f / det());
  }
};

Matriz matrizIdentidade()
{
  Matriz id = new Matriz();
  id.def(0,0,1f);
  id.def(1,1,1f);
  id.def(2,2,1f);
  return id;
}

Matriz matrizTranslacao(Coord t)
{
  Matriz trans = matrizIdentidade();
  trans.def(0, 2, t.x);
  trans.def(1, 2, t.y);
  return trans;
}

Matriz matrizEscala(Coord s)
{
  Matriz escala = matrizIdentidade();
  escala.def(0, 0, s.x);
  escala.def(1, 1, s.y);
  return escala;
}

Matriz matrizRotacao(float rad)
{
  Matriz rot = matrizIdentidade();
  rot.def(0, 0, cos(rad));
  rot.def(0, 1, sin(rad));
  rot.def(1, 0, -sin(rad));
  rot.def(1, 1, cos(rad));
  return rot;
}
