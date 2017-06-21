<h4>Titanic: Machine Learning from Disaster<h4>

https://www.kaggle.com/c/titanic

Description from kaggle:
>The sinking of the RMS Titanic is one of the most infamous shipwrecks in history.  On April 15, 1912, during her maiden voyage, the Titanic sank after colliding with an iceberg, killing 1502 out of 2224 passengers and crew. This sensational tragedy shocked the international community and led to better safety regulations for ships. One of the reasons that the shipwreck led to such loss of life was that there were not enough lifeboats for the passengers and crew. Although there was some element of luck involved in surviving the sinking, some groups of people were more likely to survive than others, such as women, children, and the upper-class. In this challenge, we ask you to complete the analysis of what sorts of people were likely to survive. In particular, we ask you to apply the tools of machine learning to predict which passengers survived the tragedy.

After reviewing the data, we can see that a lot of preprocessing can be made. The major ideas that were implemented here are described below.

1. Deciding on features<>
Out of the Passenger class, Name, Sex, Age, SibSp, Parch,	Ticket,	Fare,	Cabin, Embarked we have to decide which ones are relevant for predictions.
* Passenger class - most likely people with higher class were first to be saved, so this feature gives a clear impact.
* Name - obviously it is not possible to make predictions by the name of the person. However, there are some tricks discussed later
* Sex - this factor is likely to impact the predictions, as women were known to be saved first. Moreower, the crew that was last in the line to be saved consisted mainly of men.
* Age - as with the sex, the kids were saved first, so we can see a clear impact here as well
* SibSp - this feature defines if there were siblings or spouses on the ship. Probably children of the same family were saved or not saved together, but it is hard to say for sure. The impact of this feature has to be checked later
* Parch - defines if there were parents or children on the ship. Most likely mothers were saved together with their children, so most likely this feature gives some impact on the predictino.
* Ticket - as long as we cannot find any patterns in the ticket numbers, this information is of no use, as each ticket has a unique number that is not related to the disaster.
* Fare - more expensive tickets define better class. However, having the attribute of a class already, there is no need to add redundant information to our model.
* Cabin - information on the cabin can theoretically give information on the location of the passengers and how far they were from the survival deck. However, this feature has too many NAs, so I decided to neglect it.
* Embarked - defines the port from where the trip of the passenger started. It is not yet clear if it makes any difference
