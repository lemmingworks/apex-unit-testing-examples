# joelemmer.com Apex Unit Testing Examples

This repo contains runnable code examples to go with the posts on Apex unit testing on [www.joelemmer.com](https://www.joelemmer.com).

- [How to fix: "Uncommitted work pending" exception](https://www.joelemmer.com/how-to-fix-uncommitted-work-pending-exception)
- [How to fix: "Methods not defined as TestMethod do not support Web service callouts" exception](https://www.joelemmer.com/how-to-fix-methods-not-defined-as-testmethod)


## How to run the examples in this repo

1. Create a scratch org using sfdx.

```bash
sfdx force:org:create -f config/project-scratch-def.json -a apexmocks-examples --setdefaultusername
```

2. Push the project metadata (in this case the Apex classes containing the code) into the scratch org.

```bash
sfdx force:source:push
```

3. Run the unit tests:
- Either from within VSCode by clicking on the *Run Test* links in test files.
- Or, from the developer console via Tests -> New Run.
- Or, using sfdx e.g. `sfdx force:apex:test:run -n "Stubbing_Test" -r human`
