# incidence2 0.2.2
* Fixes bug in get_interval.
* Removes message that was displayed when incidence class dropped.
* Refactoring of internal code to improve maintainability.
* Tests now use the 3rd edition of testthat. 

# incidence2 0.2.1
* Fixes bug in as.data.frame.incidence2
* Limits internal reliance on dplyr.

# incidence2 0.2.0

* Fixes issue with monthly incidence objects when `show_cases = TRUE` (see #42).
* Additional checks added for assessing whether a manipulated incidence object
  maintains its class.
* Improved implementation speed.
* NA's now ignored in the `count` variable of a pre-aggregated input to 
  `incidence` function.
* Fixes axis labelling and spacing.


# incidence2 0.1.0

* Initial release.
