# Attribution Documentation
The goal of this project is to assign a marketing channel to each acquired customer. Two tables have been provided - `sessions` and `conversions`. The `conversions` table contains all the users along with their signup times, while the `sessions` tables provides information about all the interactive sessions for each user including the medium that led to a particular session.


## Base transformations

Looking at all the possible distinct channels that are present in the `sessions` table, we notice that there are `PAID SEARCH` and `PAID SOCIAL`  channels but no `PAID CLICK` and `PAID IMPRESSION`. In addition, there is an `ORGANIC SEARCH` channel but none called `ORGANIC CLICK`. In order to follow the custom rules provided for attribution, we will make the following transformation for channel categories. Note that this assumption will not affect the algorithm and this is done to create a dataset for which the given attribution rules can be applied. 


    PAID SEARCH --> PAID CLICK
    PAID SOCIAL --> PAID IMP
    ORGANIC SEARCH -- ORGANIC CLICK
    DIRECT --> DIRECT
    EVERYTHING ELSE --> OTHER

Additionally, the base transformation only includes sessions before the signup time. In this process, the signup time is also joined from the `conversions` table to the `sessions` table. It is useful as once the signup time is joined here, it will not have to be repeated. With the aforementioned two things implemented in `session_transformed.sql`, all sessions before the signup time and the transformed channel names are included.


## Attribution Assignment Algorithm


https://miro.com/app/embed/uXjVOjkbo7U=/


From the given custom rules, paid sessions (*paid click, paid impression*) cannot be hijacked by any other sessions, and their life span is shorter, and closer to the signup time, therefore these channels should be attributed first. 


- First, within a three hour window from the signup time, *paid click* takes precedence, except if within a one hour window, *paid impression* occurs first. Keeping this in mind, if there is any *paid click* session **between** the one hour and three hour window, that is clear winner of the trophy. These attributions are done in the `attribution_1_3_hours.sql` model.


- Second, for the attribution from the signup time until one hour, whichever occurs first between *paid click* and *paid impression*, is attributed the winner. Window function is used to rank the sessions to determine the precedence. Note that it is also important to filter out the winners from the previous case. These attributions are done in `attribution_0_1_hours.sql` model.


- Third, once the paid sessions are attributed, *organic clicks*, if they occur, are attributed for the period until twelve hours from the signup time. Paid attributions until the three hour period are filtered out as they can hijack the organic clicks. In addition, any paid sessions which happen before three hours from signup are irrelevant as they are outside the limit of their lifespan. These attribution are done in `attribution_0_12_hours.sql` model.


- Finally, direct channels are attributed as *direct* and remaining cases are aggregated into *other*. All the previously assigned attributions are filtered out. This is done is `attribution_before_12_hours.sql` model.

The algorithm has also been visually explained using a [Miro board](https://miro.com/app/board/uXjVOjkbo7U=/).

