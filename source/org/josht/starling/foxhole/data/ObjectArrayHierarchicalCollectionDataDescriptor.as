package org.josht.starling.foxhole.data
{
	import org.josht.starling.foxhole.controls.Label;

	public class ObjectArrayHierarchicalCollectionDataDescriptor implements IHierarchicalCollectionDataDescriptor
	{
		public function ObjectArrayHierarchicalCollectionDataDescriptor()
		{
		}

		public var childrenField:String = "children";

		/**
		 * @inheritDoc
		 */
		public function getLength(data:Object, ...rest:Array):int
		{
			var branch:Array = data as Array;
			const indexCount:int = rest.length;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = rest[i] as int;
				branch = branch[index][childrenField] as Array;
			}

			return branch.length;
		}

		/**
		 * @inheritDoc
		 */
		public function getItemAt(data:Object, index:int, ...rest:Array):Object
		{
			rest.unshift(index);
			var branch:Array = data as Array;
			const indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = rest[i] as int;
				branch = branch[index][childrenField] as Array;
			}
			const lastIndex:int = rest[indexCount] as int;
			return branch[lastIndex];
		}

		/**
		 * @inheritDoc
		 */
		public function setItemAt(data:Object, item:Object, index:int, ...rest:Array):void
		{
			rest.unshift(index);
			var branch:Array = data as Array;
			const indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = rest[i] as int;
				branch = branch[index][childrenField] as Array;
			}
			const lastIndex:int = rest[indexCount];
			branch[lastIndex] = item;
		}

		/**
		 * @inheritDoc
		 */
		public function addItemAt(data:Object, item:Object, index:int, ...rest:Array):void
		{
			rest.unshift(index);
			var branch:Array = data as Array;
			const indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = rest[i] as int;
				branch = branch[index][childrenField] as Array;
			}
			const lastIndex:int = rest[indexCount];
			branch.splice(lastIndex, 0, item);
		}

		/**
		 * @inheritDoc
		 */
		public function removeItemAt(data:Object, index:int, ...rest:Array):Object
		{
			rest.unshift(index);
			var branch:Array = data as Array;
			const indexCount:int = rest.length - 1;
			for(var i:int = 0; i < indexCount; i++)
			{
				var index:int = rest[i] as int;
				branch = branch[index][childrenField] as Array;
			}
			const lastIndex:int = rest[indexCount];
			const item:Object = branch[lastIndex]
			branch.splice(lastIndex, 1);
			return item;
		}

		/**
		 * @inheritDoc
		 */
		public function getItemIndex(data:Object, item:Object, result:Vector.<int> = null, ...rest:Array):Vector.<int>
		{
			if(!result)
			{
				result = new <int>[];
			}
			else
			{
				result.length = 0;
			}
			var branch:Array = data as Array;
			const restCount:int = rest.length;
			for(var i:int = 0; i < restCount; i++)
			{
				var index:int = rest[i] as int;
				result[i] = index;
				branch = branch[index][childrenField] as Array;
			}

			const isFound:Boolean = this.findItemInBranch(branch, item, result);
			if(!isFound)
			{
				result.length = 0;
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function isBranch(node:Object):Boolean
		{
			return node.hasOwnProperty(this.childrenField) && node[this.childrenField] is Array;
		}

		/**
		 * @private
		 */
		protected function findItemInBranch(branch:Array, item:Object, result:Vector.<int>):Boolean
		{
			const index:int = branch.indexOf(item);
			if(index >= 0)
			{
				result.push(index);
				return true;
			}

			const branchLength:int = branch.length;
			for(var i:int = 0; i < branchLength; i++)
			{
				var branchItem:Object = branch[i];
				if(this.isBranch(branchItem))
				{
					result.push(i);
					var isFound:Boolean = this.findItemInBranch(branchItem[childrenField] as Array, item, result);
					if(isFound)
					{
						return true;
					}
					result.pop();
				}
			}
			return false;
		}
	}
}