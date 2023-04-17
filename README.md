# Kriging app in R

Used in many applications such as Geostatistics, environemental modeling or even Mineral exploration,
Kriging is a very useful interpolation method, and we will see an illustration of it in 1D.

The main library that I am using is <code>rlibkriging</code>, the Github link of which is <link>https://github.com/libKriging/libKriging</link>.
Feel free to consult the documentation of this library at <link>https://libkriging.readthedocs.io/en/latest/</link>, for many details about it, including the complete mathematical formalization and how to install it in Python or Matlab

## Installation of packages 

Firstly you will have to install packages such as the main one : <code>rlibKriging</code> or 
others like <code>ggplot2</code> or <code>shinythemes</code>. Once R is opened on your computer you can write this down :

```R
# in R
install.packages("rlibkriging")
install.packages("shiny")
install.packages("ggplot2")
install.packages("shinythemes")
```
Then the packages are already imported in the code.

## Illustration of kriging

Once the packages are correctly installed, you can execute the code and will see this window Opened :

![](https://github.com/Oscarmour75/Kriging-app/blob/main/Images/app1.png?raw=true)


This will be very easy to understand if you are familiar with Kriging.

### How to use it

I would recommend that you do things in this order :

- Chose a function **f(x)** that you want to interpolate : the default one is $$f(x) = 1 - \frac{1}{2} \left(\frac{\sin(12x)}{1 + x} + 2\cos(7x)x^5 + 0.7\right)$$
- Chose a **Kernel**, a **number of datas** (Evenly distributed over [0,1]), and an **optimisation method**.
- RUN the model !

You will see the fitting of the function we interpolated : The real one in **black** and your prediction in blue.

Now, you can chose an **Estimation method** and run **Parameters estimation**, you will se the fitting of optimal Range and Std. 

#### No optimisation method

If you chose **None** in Optimisation method, the model will be fitted with the range and the standard Variance that you give all along the fitting (NB : the Std has 
no impact on the result which is a problem being fixed in the *Kriging* function). 

In One dimension here, the correlation terms in the GP are given by the formula :

$$C_\xi = Cov (x,x')= \sigma^2 \kappa (\frac{x-x'}{\theta})$$

- $\kappa$ is your kernel
- $\theta$ is your range 
- $\sigma^2$ is your Standard Variance
### Nugget Kriging

You can add some Noise on your datas by using **Nugget effect**

![](https://github.com/Oscarmour75/Kriging-app/blob/main/Images/app2.png?raw=true)


<br>

The known datas are now : $y_{nugget}=y+C \epsilon$ where $\epsilon \sim \mathcal{N}(0,I_n)$ and $C$ is the **nugget parameter**.
You can also change the random seed and this will affect the distributions of the $\epsilon$.

### Have fun !

We have now seen everything you can do with this Kriging App so feel free to play with it.
