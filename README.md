<h2>Titanic: Machine Learning from Disaster</h2>

https://www.kaggle.com/c/titanic

Description from kaggle:
>The sinking of the RMS Titanic is one of the most infamous shipwrecks in history.  On April 15, 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, killing 1502 out of 2224 passengers and crew. This sensational tragedy shocked the international community and led to better safety regulations for ships. One of the reasons that the shipwreck led to such loss of life was that there were not enough lifeboats for the passengers and crew. Although there was some element of luck involved in surviving the sinking, some groups of people were more likely to survive than others, such as women, children, and the upper-class. In this challenge, we ask you to complete the analysis of what sorts of people were likely to survive. In particular, we ask you to apply the tools of machine learning to predict which passengers survived the tragedy.

After reviewing the data, we can see that a lot of preprocessing can be made. The major ideas that were implemented here are described below.

<h3>1. Deciding on features</h3>
Out of the Passenger class, Name, Sex, Age, SibSp, Parch,	Ticket,	Fare,	Cabin, Embarked we have to decide which ones are relevant for predictions.
* *Passenger class* - most likely people with higher class were first to be saved, so this feature gives a clear impact.
* *Name* - obviously it is not possible to make predictions by the name of the person. However, there are some tricks discussed later
* *Sex* - this factor is likely to impact the predictions, as women were known to be saved first. Moreower, the crew that was last in the line to be saved consisted mainly of men.
* *Age* - as with the sex, the kids were saved first, so we can see a clear impact here as well
* *SibSp* - this feature defines if there were siblings or spouses on the ship. Probably children of the same family were saved or not saved together, but it is hard to say for sure. The impact of this feature has to be checked later
* *Parch* - defines if there were parents or children on the ship. Most likely mothers were saved together with their children, so most likely this feature gives some impact on the predictino.
* *Ticket* - as long as we cannot find any patterns in the ticket numbers, this information is of no use, as each ticket has a unique number that is not related to the disaster.
* *Fare* - more expensive tickets define better class. However, having the attribute of a class already, there is no need to add redundant information to our model.
* *Cabin* - information on the cabin can theoretically give information on the location of the passengers and how far they were from the survival deck. However, this feature has too many NAs, so I decided to neglect it.
* *Embarked* - defines the port from where the trip of the passenger started. It is not yet clear if it makes any difference

<h3>2. Substituting missing values</h3>
The basic approach to this problem is to substitute the value with the mean value of this feature. This works fine for "Embarked" attribute. For the "Fare", we can substitute the missing or 0 price with a mean of the class. However, for the "Age" attribute, missing values comprise 20% of the whole set. Therefore, we need to come up with a more accurate approach. For example, we can use the title from the name field - we know that Master is a young boy and Miss is a young girl, etc. We can use this feature to substitute the missing age values for the mean inside of the title class.

<h3>3. Introducing Titles</h3>
As described above, a lot of names come with a prefix. The following ones are present: "Capt", "Col", "Don", "Dr", "Jonkheer", "Lady", "Major", "Rev", "Sir", "Countess", "Aristocratic", "Ms", "Mrs", "Mlle", "Mme", "Miss", "Mr", "Master". After reviewing the meaning of each of them, we can simplify them to 5 titles: Mr, Miss, Mrs, Master, Aristocratic and use them as a new feature in our dataframe.
reference: https://habrahabr.ru/company/mlclass/blog/270973/

Features "Fare", "SibSp", "Cabin" were removed after testing the model, as they did not improve the accuracy of the results. On the other hand, feature "Parch" showed some importance.

After all, the best result was achieved with Random Forest and it was 79.904%. Other models that I tried were Support Vector Machines, Decision Trees and k-Nearest Neighbors. This is quite sad as it it is not much better than the accuracy obtained by prediction solely based on sex. This is not a surprise with such data, but at least feature engineering was fun.
