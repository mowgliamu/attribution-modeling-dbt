This document is best viewed here: https://paper.dropbox.com/doc/Attribution-Documentation--Bl6b8UUno6DOCrwFqfL5LnbTAg-PdqPN2RVvtEhhSBYfoIkL

# Attribution Documentation
The goal of this project is to assign a marketing channel to each acquired customer. Two tables have been provided - `sessions` and `conversions`. The `conversions` table contains all the users along with their signup times, while the `sessions` tables provides information about all the interactive sessions for each user including the medium that led to a particular session.


## Base transformations

Looking at all the possible distinct channels that are present in the `sessions` table, we notice that there are `PAID SEARCH` and `PAID SOCIAL`  channels but no `PAID CLICK` and `PAID IMPRESSION`. In addition, there is an `ORGANIC SEARCH` channel but none called `ORGANIC CLICK`. In order to follow the custom rules provided for attribution, we will make the following transformation for channel categories. Note that this assumption will not affect the algorithm and this is done to create a dataset for which the given attribution rules can be applied. 


    PAID SEARCH --> PAID CLICK
    PAID SOCIAL --> PAID IMP
    ORGANIC SEARCH -- ORGANIC CLICK
    DIRECT --> DIRECT
    EVERYTHING ELSE --> OTHER

In addition to this transformation, the base transformation will only include sessions which have taken place before the signup time. In this process, the signup time is also joined from the `conversions` table to the `sessions` table. This is useful because once the signup time is joined here, we will not have to repeat it again and again.

With these two things implemented in `session_transformed.sql`, we have all the sessions that happened before the signup time, with the channels name transformed.


## Attribution Assignment Algorithm


[https://miro.com/app/board/uXjVOjkbo7U=/](https://miro.com/app/board/uXjVOjkbo7U=/)

According to the given custom rules, since paid sessions (paid click, paid imp) cannot be hijacked by any other sessions, and their life span is shorter, and closer to the signup time, these channels should be attributed first. Within a three hour window from the signup time, paid click takes precedence, except if within a one hour window, paid impression occurs first. Keeping this in mind, if there is any paid click session **between** the one hour and three hour window, that is clear winner of the trophy. These are assigned in the `attribution_1_3_hours.sql`.

Next, the attribution from the signup time until one hour is tackled. This is a slightly tricky case because both paid click and paid impression can win the trophy, depending on which occurs first. Window function to rank the sessions is used here to decide the winner. It is also important to filter out the winners from the previous case. These attributions are done in `attribution_0_1_hours.sql`. 

Once the paid sessions are attributed, the organic clicks can be attributed for the period until twelve hours from the signup, if it occurs even once in this period. We filter out the paid attributions until the three hour period as they can hijack the organic clicks. In addition, any paid sessions which happen before three hours from signup are irrelevant as they are outside the limit of their lifespan. These attribution are performed in `attribution_0_12_hours.sql`. 

Rest of the attribution is easy - direct channels are attributed as direct while everything else has been aggregated into other. All the previously assigned attributions are filtered out. This is done is `attribution_before_12_hours.sql`. 

The algorithm has also been visually explained using a Miro board. 

