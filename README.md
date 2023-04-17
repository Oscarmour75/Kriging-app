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

![texte alternatif](https://lh3.googleusercontent.com/C3EubzdFZ8g9PB1woj-RIBkcoM2Rb3BEteecYwTIYFypFHsxf8JrMJgC5qReV3qdTSuQyX1TM346rQ7mB00PO3hhJ6gTCoDEZKNByYgAh8k_YO05yW3QlapqZlipUh1ZAHnnI4v7f1yxXpeLd_GfRSKl6Q9LzKgfWES1st1NlKpmjp3ledymjWeRZMIUICCVNFJbH8GwEHR3_GaTWcTRaC8AU4T94rEIePNm7cVTB9c27GpIQSJgJBn5qnVQ0mpxKLITmx3n0kTlp2AAv29yWjs8AiU9KyTV15VFctaEdL7_oPlVEhqgYEG3ipOpIaLoa8sjQm5XMbq8NI4EYZa49wxiURMyhJkw5owiB35mJFxOGbbF7Kg6dTn6-N5j9z1ucqUirJ9y5vvxcvR4p0qKZAxKssvZtVb0t7HykJHh33e8FRYQjSGpajZ9JgcKorJbWNBgZcpzXtgSUSzhBCYMIcfnV-TO-AZbmQsSDjsEFP1-PL6pOwNOd7nVL4bgawShMOJim26F6od6rORRp5BZUEZTb4h2f2skx8DOUaTZnN6zrKiqKyhx7FTBgPfksLk3e9RNeXWHyORNfwU9jALsv1vfXLi2AcrDGTpwnw0GZFzBc9lN532po5EQKxm3D8iczEiI-ZtXNU08ibcn4KBhtxZ3KNY-ZSCzWDwUede2k0AnvJw8XDl-Z9aDrjs0oGvrVcd-leT3Rrsx_rtIUx8x0KAjNIIxCU1kVjo-D9V8QOaxHNzVcxHtD2ogYCkT9qwf6AWyQDAlsXA6_3pdKpqdJW3oAGyZ6hXJABfhGBs1c0XebSR7aoH1kQlESQeLy9GRrYzqUntjHB-mK6vXnO0DM0u-X9z5_Ey2OVTN5mpNm5p2QOzvFki1VeWBqKjsT2Y-SmOK_b-VomR0nNt-aD27VEEBiO8PO74xhCjAbL5irz2-83J6=w1871-h945-s-no?authuser=0)


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

![texte alternatif](https://lh3.googleusercontent.com/2RXW94TSti0cVCfd7L5WeILK94hunSRAiZiqnyphv4MmqMkG1jo192SC3cNNxdnObwSCCnBnsbSIJMYW_fexDIfUwl82T-mh9DXgbKG5h65TyA2pOqaMk4yxERM5xOAVXgCRwFfcnrV3Q4EQIklTUkg9y5AItBIBo6HFwg9lppPGQwYDQHDJ2BO8sw0J7pwg9_YuEJMqjnwyMaGcs-_2RAp0D3SnfbpW5zP5Fvbua1kak5xCY7ktlY6hRlswOCkNKgeSUi_3PhGKdYbkqEsCeKhz3KGjglisjz3aln6yIPxQwAjQCb7O-nd5diLTMyvNRXCIarVGVoR4XWNlSJJVCvKXEqRkiBdeib7uIwOBTHqXcuKXc-mNmmyOPCQLLCjmFiAiMRUJJZnTfu4XxF7HKEAu9Fq07W2wsnIF5sj2imn_77KAVrPwVDzxUi4xsQLhGxppdq4nZ0D4gxMg8YjakrqpXdC_8xu1cA40CSCDg3k1bWlysWruYbYmaNhuPISUdxQrJQO_HM8fWWTNd1e31pTlgmgAhdvBcvc6pJZZG_paMB6EN8SSVGJe9ctjsQrv1yLk4gQqW3_ParU-hg-axWOfFmFXy8XVWTkS8b24SpfCFySKN99rX4IcrvO67b2MUCLcW1j4Jlk4TlWJtOiKDxNg5WoCpv3E2Nvipa4VzLWhRPZB8IdicEbf3njqTfe6LbKCvIHhCnhCC8POMTJ-Uvoi_Zmnu5w53puQWEjqEFAIYS1pzuQE7m-6fQtTVCELdCp-rg597fwxk2U8z2_59_B6ih7SYIvzF0Prm_KK5JHO_rk1N596Th0qZ95Tcnqf9OW2Qwl150FV41GejBrzjFvafx4i1JB5F0DhescLY2f6BkLD57X4q6cFOni1bLPFy5IFa2UH1DeSJ2spQOZlnkvvf7GsmEi5-jUJODeQXcYoGq1u=w1851-h941-s-no?authuser=0)

<br>

The known datas are now : $y_{nugget}=y+C \epsilon$ where $\epsilon \sim \mathcal{N}(0,I_n)$ and $C$ is the **nugget parameter**.
You can also change the random seed and this will affect the distributions of the $\epsilon$.

### Have fun !

We have now seen everything you can do with this Kriging App so feel free to play with it.
