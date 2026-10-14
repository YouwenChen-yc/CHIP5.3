# Part 0.B - Preparing to Deploy To Render

## Initial Render Deployment

For those interested in using [Render.com](https://www.render.com) to deploy their application, you might want to look
at the following:
1. [Here is the Render.com](https://render.com/docs/deploy-rails-6-7) documentation on deploying your Rails 6 or 7 
application to Render. You can likely skip 
steps 1 and 2, since we already have an application you can deploy. Step 3 introduces a deployment script required by 
Render. We have provided that script in the `/bin` directory ([bin/render-build.sh](bin/render-build.sh)).
2. There are more steps to complete, including provisioning your database. Refer to their documentation for those
details.

## Next
[Part 1 - Filter The Movies List By Rating](Part-1-Filter-Movies-List-By-Rating.md)