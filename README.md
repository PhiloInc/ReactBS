<h1 align="center">ReactBS</h1>

<div align="center">
	React-like framework for Roku
</div>

## Usage

- Copy the files in `components/react` to your project.
- Extend the `React`* components.
- Override component lifecycle functions as needed. `render`, `componentDidUpdate`, `componentWillUnmount`, `shouldComponentUpdate` are available.
- Call `mapFieldsToProps` function to map properties under `m.top` to `m.props`.
- Call `unmountComponent` to unmount a component.

## Caveat

This framework is in beta. Future changes to the framework may not be backwards compatible.


## License
ReactBS is licensed under the
MIT License. See [LICENSE.txt](LICENSE.txt) for details.
